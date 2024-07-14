# frozen_string_literal: true

RSpec.describe Cryptoform::EncryptionBackends::Lockbox do
  let(:backend) { described_class.new("test", key: -> { key }) }
  let(:key) { Lockbox.generate_key }
  let(:text) { SecureRandom.hex }

  it "successfuly encrypts and decrypts given text" do
    encrypted = backend.encrypt(text)
    expect(encrypted).not_to eq(text)
    expect(backend.decrypt(encrypted)).to eq(text)
  end
end
