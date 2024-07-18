# frozen_string_literal: true

module Cryptoform::CLI::Init
  class << self
    def included(thor) # rubocop:disable Metrics/AbcSize
      thor.class_eval do
        desc "init", "initialize project"
        option :cryptofile, type: :string, default: Cryptoform::CRYPTOFILE
        option :generate_key, type: :boolean, default: true
        option :port, type: :numeric, default: 3000
        option :name, type: :string, default: "state"
        option :storage_backend, type: :string, default: "file"
        option :encryption_backend, type: :string, default: "diff_lockbox"
        option :force, type: :boolean, default: false

        def init # rubocop:disable Metrics/AbcSize
          if File.exist?(cryptofile_path) && !options[:force]
            puts("#{cryptofile_path} already exists, is the project already initialized?")
            exit(1)
          end

          config_generator = Cryptoform::ConfigGenerator.new(
            **options.slice(:name, :port, :storage_backend, :encryption_backend).transform_keys(&:to_sym)
          )
          cryptofile = config_generator.generate_cryptofile
          config = Cryptoform.load_cryptofile!(cryptofile)

          if options[:generate_key]
            key = config.config.states[options[:name].to_sym].encryption_backend.generate_key
            puts("We generated a key for you, pass it to Cryptoform as \"CRYPTOFORM_KEY\" environment variable")
            puts("Key: #{key}")
          end

          File.write(cryptofile_path, cryptofile)
          puts("#{cryptofile_path} is written!")

          puts("Use this to configure you terraform backend:")
          puts(config_generator.generate_terraform_backend)

          puts("And this to configure a terraform remote state data source:")
          puts(config_generator.generate_terraform_remote_state_data_source)

          puts("All done, you can start using Cryptoform. To run the server execute:")
          command = "bundle exec cryptoform"
          command += " --cryptofile #{cryptofile_path}" if cryptofile_path != Cryptoform::CRYPTOFILE

          puts(command)
        end
      end
    end
  end
end
