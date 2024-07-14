# frozen_string_literal: true

RSpec.describe Cryptoform::EncryptionBackends::Lockbox do
  let(:backend) { described_class.new("test", key: -> { key }) }
  let(:key) { Lockbox.generate_key }
  let(:content) do
    {
      user: {
        id: 12_345,
        name: "John Doe",
        email: "john.doe@example.com",
        profile: {
          age: 30.5,
          bio: "Software Developer from California",
          social_media: {
            twitter: "@johndoe",
            linkedin: "linkedin.com/in/johndoe",
            websites: [
              {
                name: "Personal Blog",
                url: "https://johndoe.com",
                tags: ["technology", "programming", "lifestyle"]
              },
              {
                name: "GitHub",
                url: "https://github.com/johndoe",
                repos: [
                  {
                    name: "Project One",
                    description: "A project about something interesting",
                    languages: ["Python", "JavaScript"],
                    stars: 150,
                    forks: 30,
                    issues: {
                      open: 5,
                      closed: 20
                    }
                  },
                  {
                    name: "Project Two",
                    description: "Another project about something else",
                    languages: ["Go", "Rust"],
                    stars: 75,
                    forks: 10,
                    issues: {
                      open: 2,
                      closed: 8
                    }
                  }
                ]
              }
            ]
          }
        },
        preferences: {
          newsletter: true,
          notifications: {
            email: true,
            sms: false,
            push: {
              enabled: true,
              sound: "chime",
              vibration: true
            }
          }
        }
      },
      settings: {
        theme: "dark",
        privacy: {
          profile_visibility: "friends",
          data_sharing: false
        },
        language: "en"
      },
      metadata: {
        created_at: "2023-01-01T12:00:00Z",
        updated_at: "2023-06-15T08:45:00Z",
        tags: ["sample", "json", "document"],
        ratings: nil
      }
    }
  end

  it "successfuly encrypts and decrypts given text" do
    encrypted = backend.encrypt(content)
    expect(encrypted).not_to eq(content)
    expect { JSON.parse(encrypted) }.to raise_error(JSON::ParserError)
    expect(backend.decrypt(backend.encrypt(content))).to eq(content)
  end
end
