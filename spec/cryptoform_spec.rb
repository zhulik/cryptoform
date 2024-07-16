# frozen_string_literal: true

RSpec.describe Cryptoform do
  it "has a version number" do
    expect(Cryptoform::VERSION).not_to be_nil
  end

  describe ".run" do
    subject { described_class.run!(cryptofile) }

    let(:cryptofile) do
      <<-RUBY
      port 3000

      state :state do
        storage_backend :file
        encryption_backend :lockbox, key: -> { ENV.fetch("CRYPTOFORM_KEY") }
      end
      RUBY
    end

    let(:server_stub) { instance_double(Cryptoform::Server) }

    before do
      allow(Cryptoform::Server).to receive(:run!)
    end

    it "runs the server" do
      expect { subject }.not_to raise_error
    end
  end
end
