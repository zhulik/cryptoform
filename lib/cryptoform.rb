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
end
