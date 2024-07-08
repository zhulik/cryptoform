# frozen_string_literal: true

require "zeitwerk"
require "logger"

require "lockbox"
require "async/http"

loader = Zeitwerk::Loader.for_gem

loader.setup

class Cryptoform::Error < StandardError
  # Your code goes here...
end
