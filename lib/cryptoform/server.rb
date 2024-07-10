# frozen_string_literal: true

class Cryptoform::Server
  def initialize(config)
    @config = config
  end

  def run
    logger.info { "Cryptoform is listening on #{endpoint.url}..." }
    Async::HTTP::Server.for(endpoint) do |request|
      log_request(request) { handle_request(request) }
    end.run
  end

  private

  def handle_request(request) # rubocop:disable Metrics/AbcSize
    name = request.path.split("/")&.[](1)&.to_sym
    return ::Protocol::HTTP::Response[404, {}, []] unless @config.states.key?(name)

    handler_name = :"#{request.method.downcase}_state"
    return ::Protocol::HTTP::Response[405, {}, []] unless respond_to?(handler_name, true)

    send(handler_name, @config.states[name], request:)
  rescue Cryptoform::StateMissingError
    ::Protocol::HTTP::Response[404, {}, []]
  rescue StandardError => e
    logger.error(e)
    ::Protocol::HTTP::Response[500, {}, []]
  end

  def get_state(state_config, *)
    ::Protocol::HTTP::Response[200, {}, [state_config.encryption_backend.decrypt(state_config.storage_backend.read)]]
  end

  def post_state(state_config, request:)
    state_config.storage_backend.write(state_config.encryption_backend.encrypt(request.body.read))

    ::Protocol::HTTP::Response[201, {}, []]
  end

  def logger = @logger ||= Logger.new($stdout)

  def endpoint = @endpoint ||= Async::HTTP::Endpoint.parse("http://localhost:#{@config.port}")

  def log_request(request)
    yield.tap do |response|
      logger.info { "#{request.method} #{request.path}: #{response.status}" }
    end
  end
end
