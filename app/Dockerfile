FROM ruby:3.4.2

WORKDIR /app

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client vim

COPY Gemfile Gemfile.lock ./


RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
