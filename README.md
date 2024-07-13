# Cryptoform

Implemented as an http backend, cryptoform encypts your state using one of the providers and stores in one
on the backends. Currently only [lockbox](https://github.com/ankane/lockbox) provider and file backend 
are supported. The tool designed to be modular so other encryption providers and backends may be added
later on.

## Why

Even though it's strongly recommended to use S3 or some other 3rd party service to store the state, and 
using git to store it is discouraged, sometimes it's still very handy to not have any external services
and store the state in git, encryted for better safety. For instance: you work on the project alone and
you don't need locking(an external lock mechanism can be supported in the future) and you don't want to
bother configuring an external state store.

## Installation

1. Install one of supported ruby versions: 3.1 or newer
2. In your terraform project, create 2 files:
    
    *Gemfile*:
    ```ruby
    # frozen_string_literal: true

    source "https://rubygems.org"

    gem "cryptoform"
    ```
3. Run `bundle install`
4. TODO: Run `bundle exec rake cryptoform:init` and save the printed key.
5. Run `CRYPTOFORM_KEY=<key from the previous step> bundle exec cryptoform`
6. Configure your terraform backend:
    ```hcl
    terraform {
        backend "http" {
            address = "http://127.0.0.1:3000/state"
        }
    }
    ```

TODO: ship in docker?

## Cryptofile

TODO: Write Cryptofile details here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cryptoform. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/cryptoform/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cryptoform project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/cryptoform/blob/main/CODE_OF_CONDUCT.md).
