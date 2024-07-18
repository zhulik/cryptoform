# frozen_string_literal: true

module Cryptoform::CLI::Server
  class << self
    def included(thor)
      thor.class_eval do
        desc "server", "run cryptoform server"
        option :cryptofile, type: :string, default: Cryptoform::CRYPTOFILE

        def server
          Cryptoform.run!(File.read(cryptofile_path))
        end
      end
    end
  end
end
