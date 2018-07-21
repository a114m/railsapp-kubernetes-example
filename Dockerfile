FROM ruby:2.2.3-slim

RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends

WORKDIR /app

COPY Gemfile Gemfile
RUN bundle install

COPY . .

# The default command that gets ran will be to start the Unicorn server.
CMD bundle exec unicorn -c config/unicorn.rb
