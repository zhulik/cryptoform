# frozen_string_literal: true

class Cryptoform::Application < Sinatra::Application
  def initialize(config)
    super
    @states = config.states
  end

  get "/states/:name" do
    state = state_config.encryption_backend.decrypt(state_config.storage_backend.read)
    json state
  rescue Cryptoform::StateMissingError
    raise Sinatra::NotFound
  end

  post "/states/:name" do
    state = JSON.parse(request.body.read)
    state_config.storage_backend.write(state_config.encryption_backend.encrypt(state))
    json(state)
  end

  private

  def state_config
    name = params[:name].to_sym
    @states[name] || raise(Sinatra::NotFound, "state #{name} is not configured in Cryptofile")
  end
end
