# frozen_string_literal: true

RSpec.describe Cryptoform do
  it "has a version number" do
    expect(Cryptoform::VERSION).not_to be_nil
  end

  # describe ".run" do
  #   subject { described_class.run(cryptofile) }

  #   let(:cryptofile) do
  #     <<-RUBY
  #     port 3000

  #     state :state do
  #       storage_backend :file
  #       encryption_backend :lockbox, key: -> { ENV.fetch("CRYPTOFORM_KEY") }
  #     end
  #     RUBY
  #   end

  #   let(:server_stub) { instance_double(Cryptoform::Server) }

  #   before do
  #     allow(Cryptoform::Server).to receive(:new).and_return(server_stub)
  #     allow(server_stub).to receive(:run)
  #   end

  #   xit "runs the server" do
  #     subject
  #     expect(server_stub).to have_received(:run)
  #   end
  # end
end
