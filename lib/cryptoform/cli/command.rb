# frozen_string_literal: true

class Cryptoform::CLI::Command
  class << self
    def thor(&)
      Cryptoform::CLI::App.class_eval(&)
    end
  end
end
