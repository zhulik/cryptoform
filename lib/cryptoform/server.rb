# frozen_string_literal: true

class Cryptoform::Server < Sinatra::Application
  set :show_exceptions, false

  before do
    content_type "application/json"
  end

  class << self
    def run!(config, **)
      Cryptoform::Server.port = config.port
      Cryptoform::Server.set(:states, config.states)
      super(**)
    end
  end

  get "/" do
    json(
      cryptoform: {
        version: Cryptoform::VERSION
      }
    )
  end

  get "/states" do
    json(settings.states.transform_values { {} })
  end

  get "/states/:name" do
    state = state_config.encryption_backend.decrypt(state_config.storage_backend.read)
    json(state)
  end

  post "/states/:name" do
    state = JSON.parse(request.body.read, symbolize_names: true)
    state_config.storage_backend.write(state_config.encryption_backend.encrypt(state))
    json(state)
  end

  error Cryptoform::StateMissingError, Cryptoform::UnknownStateError do |e|
    status 404
    json(error: e.message)
  end

  error Sinatra::NotFound do |_e|
    status 404
    json(error: "Not found")
  end

  error 500 do
    json(error: "Internal server error")
  end

  private

  def state_config
    name = params[:name].to_sym
    settings.states[name] || raise(Cryptoform::UnknownStateError, "state '#{name}' is not configured in Cryptofile")
  end
end
