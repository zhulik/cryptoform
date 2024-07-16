# frozen_string_literal: true

class Cryptoform::ConfigGenerator
  def initialize(name:, port:, storage_backend:, encryption_backend:)
    @name = name
    @port = port
    @storage_backend = storage_backend
    @encryption_backend = encryption_backend
  end

  def generate_cryptofile
    <<~RUBY
      # frozen_string_literal: true

      port #{@port}

      state :#{@name} do
        storage_backend :#{@storage_backend}
        encryption_backend :#{@encryption_backend}, key: -> { ENV.fetch("CRYPTOFORM_KEY") }
      end
    RUBY
  end

  def generate_terraform_backend
    <<~HCL
      terraform {
        backend "http" {
          address = "http://127.0.0.1:#{@port}/states/#{@name}"
        }
      }
    HCL
  end

  def generate_terraform_remote_state_data_source
    <<~HCL
      data "terraform_remote_state" "#{@name}_remote_state" {
        backend = "http"

        config = {
          address = "http://127.0.0.1:#{@port}/states/#{@name}"
        }
      }
    HCL
  end
end
