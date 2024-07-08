# frozen_string_literal: true

class Cryptoform::Server
  def initialize(config)
    @config = config
  end

  def run
    Sync do
      logger.info { "Cryptoform is listening on #{endpoint.url}..." }
      Async::HTTP::Server.for(endpoint) { handle_request(_1) }.run
    end
  end

  # lb = lockbox
  # ciphertext = lb.encrypt("hello")
  # pp ciphertext
  # pp lb.decrypt(ciphertext)

  private

  def handle_request(_request)
    ::Protocol::HTTP::Response[200, {}, ["Hello World"]]
  end

  def logger = @logger ||= Logger.new($stdout)

  # No memoization on purpose
  def lockbox = Lockbox.new(key: @config.key.call, encode: true)

  def endpoint = @endpoint ||= Async::HTTP::Endpoint.parse("http://localhost:#{@config.port}")
end
