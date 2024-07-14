# frozen_string_literal: true

class Cryptoform::AppBuilder
  class << self
    def build(config) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      states = config.states

      Class.new(Sinatra::Application) do
        states.each do |name, state_config|
          get "/#{name}" do
            state = state_config.encryption_backend.decrypt(state_config.storage_backend.read)
            json state
          rescue Cryptoform::StateMissingError
            raise Sinatra::NotFound
          end

          post "/#{name}" do
            state = JSON.parse(request.body.read)
            state_config.storage_backend.write(state_config.encryption_backend.encrypt(state))
            ""
          end
        end
      end
    end
  end
end
