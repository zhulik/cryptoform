# frozen_string_literal: true

require "logger"

require "lockbox"
require "sinatra"
require "sinatra/json"
require "thor"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem

loader.inflector.inflect("cli" => "CLI")

loader.setup

module Cryptoform
  CRYPTOFILE = "Cryptofile"

  class Error < StandardError; end
  class ConfigValidationError < Cryptoform::Error; end
  class StateMissingError < Cryptoform::Error; end
  class UnknownStateError < Cryptoform::Error; end

  class << self
    def run!(cryptofile)
      config = load_cryptofile!(cryptofile)
      Cryptoform::Server.run!(config.config)
    end

    def load_cryptofile!(cryptofile)
      Cryptoform::Config::Builder.new(cryptofile)
    end
  end
end
