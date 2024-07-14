# frozen_string_literal: true

class Cryptoform::Server
  def initialize(config)
    @config = config
  end

  def run # rubocop:disable Metrics/MethodLength
    server = WEBrick::HTTPServer.new(
      Port: @config.port,
      BindAddress: "0.0.0.0",
      AccessLog: [
        [$stdout, WEBrick::AccessLog::COMMON_LOG_FORMAT],
        [$stdout, WEBrick::AccessLog::REFERER_LOG_FORMAT]
      ]
    )
    trap "INT" do
      server.shutdown
    end

    server.mount("/", Rackup::Handler::WEBrick, app)

    server.start
  end

  private

  def app
    @app ||= Cryptoform::AppBuilder.build(@config)
  end
end
