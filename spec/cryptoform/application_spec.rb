# frozen_string_literal: true

RSpec.describe Cryptoform::Application do
  include Rack::Test::Methods

  def parsed_body
    JSON.parse(last_response.body, symbolize_names: true)
  end

  let(:encryption_backend1) { instance_double(Cryptoform::EncryptionBackends::Lockbox) }
  let(:encryption_backend2) { instance_double(Cryptoform::EncryptionBackends::Lockbox) }

  let(:storage_backend1) { instance_double(Cryptoform::StorageBackends::File) }
  let(:storage_backend2) { instance_double(Cryptoform::StorageBackends::File) }

  let(:app) { described_class }
  let(:states) do
    {
      state1: Cryptoform::Config::StateConfigBuilder::Config.new(storage_backend1, encryption_backend1),
      state2: Cryptoform::Config::StateConfigBuilder::Config.new(storage_backend2, encryption_backend2)
    }
  end

  let(:config) { Cryptoform::Config::Builder::Config.new(3000, states) }

  before do
    app.set(:states, states)
  end

  describe ".run!" do
    before do
      allow(Sinatra::Application).to receive(:run!)
    end

    it "runs the server" do
      expect { described_class.run!(config) }.not_to raise_error
    end
  end

  describe "GET /" do
    it "returns server info" do
      get "/"
      expect(last_response).to be_ok
      expect(parsed_body).to eq({ cryptoform: { version: "0.4.0" } })
    end
  end

  describe "GET /states" do
    it "returns states list" do
      get "/states"
      expect(last_response).to be_ok
      expect(parsed_body).to eq({ state1: {}, state2: {} })
    end
  end

  describe "GET /states/:name" do
    context "when state exists" do
      before do
        allow(storage_backend1).to receive(:read).and_return("some enrypted content")
        allow(encryption_backend1).to receive(:decrypt).with("some enrypted content")
                                                       .and_return({ some: "unencrypted content" })
      end

      it "returns state" do
        get "/states/state1"
        expect(last_response).to be_ok
        expect(parsed_body).to eq({ some: "unencrypted content" })

        expect(storage_backend1).to have_received(:read)
        expect(encryption_backend1).to have_received(:decrypt)
      end
    end

    context "when state is missing" do
      before do
        allow(storage_backend1).to receive(:read).and_raise(Cryptoform::StateMissingError, "state is missing")
      end

      it "returns 404" do
        get "/states/state1"
        expect(last_response).to be_not_found
        expect(parsed_body).to eq({ error: "state is missing" })
        expect(storage_backend1).to have_received(:read)
      end
    end

    context "when state is not configured" do
      it "returns 404" do
        get "/states/state3"
        expect(last_response).to be_not_found
        expect(parsed_body).to eq({ error: "state 'state3' is not configured in Cryptofile" })
      end
    end
  end

  describe "POST /states/:name" do
    context "when state exists" do
      before do
        allow(storage_backend1).to receive(:write).with("some enrypted content")
        allow(encryption_backend1).to receive(:encrypt).with({ some: "unencrypted content" })
                                                       .and_return("some enrypted content")
      end

      it "returns state" do
        post "/states/state1", { some: "unencrypted content" }.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response).to be_ok
        expect(parsed_body).to eq({ some: "unencrypted content" })

        expect(storage_backend1).to have_received(:write)
        expect(encryption_backend1).to have_received(:encrypt)
      end
    end

    context "when state is not configured" do
      it "returns 404" do
        post "/states/state3", { some: "unencrypted content" }.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response).to be_not_found
        expect(parsed_body).to eq({ error: "state 'state3' is not configured in Cryptofile" })
      end
    end
  end

  context "when an unknown url is requested" do
    it "returns 404" do
      get "/foo"
      expect(last_response).to be_not_found
      expect(parsed_body).to eq({ error: "Not found" })
    end
  end
end
