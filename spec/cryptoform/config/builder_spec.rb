# frozen_string_literal: true

RSpec.describe Cryptoform::Config::Builder do
  let(:builder) { described_class.new(cryptofile) }
  let(:cryptofile) do
    <<-RUBY
      port 3000

      state :state do
        storage_backend :file
        encryption_backend :lockbox, key: -> { ENV.fetch("CRYPTOFORM_KEY") }
      end
    RUBY
  end

  describe "#validate!" do
    subject { builder.validate! }

    context "when everything is configured correctly" do
      it "does not raise" do
        expect { subject }.not_to raise_error
      end
    end

    context "when storage backend is not configured" do
      let(:cryptofile) do
        <<-RUBY
        state :state do
          encryption_backend :lockbox, key: -> { ENV.fetch("CRYPTOFORM_KEY") }
        end
        RUBY
      end

      it "raises" do
        expect { subject }.to raise_error(Cryptoform::ConfigValidationError)
      end
    end

    context "when encryption backend is not configured" do
      let(:cryptofile) do
        <<-RUBY
        state :state do
          storage_backend :file
        end
        RUBY
      end

      it "raises" do
        expect { subject }.to raise_error(Cryptoform::ConfigValidationError)
      end
    end

    ["nil", -1, -3000, 0, 65_536].each do |port|
      context "when invalid port #{port}" do
        let(:cryptofile) do
          <<-RUBY
          port #{port}

          state :state do
            storage_backend :file
            encryption_backend :lockbox, key: -> { ENV.fetch("CRYPTOFORM_KEY") }
          end
          RUBY
        end

        it "raises" do
          expect { subject }.to raise_error(Cryptoform::ConfigValidationError)
        end
      end
    end

    context "when no states configured" do
      let(:cryptofile) do
        ""
      end

      it "raises" do
        expect { subject }.to raise_error(Cryptoform::ConfigValidationError)
      end
    end
  end

  describe "#config" do
    subject { builder.config }

    it "returns cryptoform config built from the cryptofile" do
      expect(subject.port).to eq(3000)
      expect(subject.states[:state].storage_backend).to be_an_instance_of(Cryptoform::StorageBackends::File)
      expect(subject.states[:state].encryption_backend).to be_an_instance_of(Cryptoform::EncryptionBackends::Lockbox)
    end
  end
end
