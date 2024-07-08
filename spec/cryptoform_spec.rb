# frozen_string_literal: true

RSpec.describe Cryptoform do
  it "has a version number" do
    expect(Cryptoform::VERSION).not_to be_nil
  end
end
