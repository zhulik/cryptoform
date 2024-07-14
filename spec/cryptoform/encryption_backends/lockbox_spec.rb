# frozen_string_literal: true

RSpec.describe Cryptoform::EncryptionBackends::Lockbox do
  let(:backend) { described_class.new("test", key: -> { key }) }
  let(:key) { Lockbox.generate_key }
  let(:content) { { test: SecureRandom.hex } }

  it "successfuly encrypts and decrypts given text" do
    encrypted = backend.encrypt(content)
    expect(encrypted).not_to eq(content)
    expect { JSON.parse(encrypted) }.to raise_error(JSON::ParserError)
    expect(backend.decrypt(backend.encrypt(content))).to eq(content)
  end
end
