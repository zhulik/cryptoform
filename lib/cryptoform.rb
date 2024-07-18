# frozen_string_literal: true

require "logger"

require "lockbox"
require "sinatra"
require "sinatra/json"
require "thor"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem

loader.setup

module Cryptoform
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
      Cryptoform::Config::Builder.new(cryptofile).tap(&:validate!)
    end
  end
end
