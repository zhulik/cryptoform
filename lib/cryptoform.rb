# frozen_string_literal: true

require "zeitwerk"
require "logger"

require "lockbox"
require "sinatra"
require "sinatra/json"

loader = Zeitwerk::Loader.for_gem

loader.setup

module Cryptoform
  class Error < StandardError; end
  class ConfigValidationError < Cryptoform::Error; end
  class StateMissingError < Cryptoform::Error; end
  class UnknownStateError < Cryptoform::Error; end

  class << self
    def run(cryptofile)
      config = Cryptoform::Config::Builder.new(cryptofile)
      config.validate!
      Cryptoform::Application.run!(config.config)
    end
  end
end
