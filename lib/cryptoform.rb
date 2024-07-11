# frozen_string_literal: true

require "zeitwerk"
require "logger"

require "lockbox"
require "async/http"

loader = Zeitwerk::Loader.for_gem

loader.setup

module Cryptoform
  class Error < StandardError; end
  class ConfigValidationError < Cryptoform::Error; end
  class StateMissingError < Cryptoform::Error; end

  class << self
    def run(path)
      config = Cryptoform::Config::Builder.new.tap { _1.instance_eval(File.read(path)) }
      config.validate!
      Cryptoform::Server.new(config.config).run
    end
  end
end
