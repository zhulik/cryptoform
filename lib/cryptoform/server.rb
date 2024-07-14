# frozen_string_literal: true

class Cryptoform::Server
  def initialize(config)
    @server = WEBrick::HTTPServer.new(
      Port: config.port,
      BindAddress: "0.0.0.0",
      AccessLog: [
        [$stdout, WEBrick::AccessLog::COMMON_LOG_FORMAT],
        [$stdout, WEBrick::AccessLog::REFERER_LOG_FORMAT]
      ]
    )
    trap("INT") { @server.shutdown }

    @server.mount("/", Rackup::Handler::WEBrick, Cryptoform::Application.new(config))
  end

  def run
    @server.start
  end
end
