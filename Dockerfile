FROM ruby:3.3.3-alpine AS base
RUN bundle config set without 'development test' &&\
    bundle config set path 'vendor/bundle'

FROM base AS builder

RUN apk add --no-cache alpine-sdk git

WORKDIR /app

COPY lib/cryptoform/version.rb ./lib/cryptoform/version.rb
COPY Gemfile Gemfile.lock *.gemspec ./
RUN bundle install -j$(nproc) --no-cache &&\
    rm -rf vendor/bundle/ruby/*/cache

COPY . .

FROM base

# TODO: get rid of git here
RUN apk add --no-cache git

COPY --from=builder /app/ /app

EXPOSE 3000

WORKDIR /app/mnt

CMD ["bundle", "exec", "../exe/cryptoform"]