FROM ruby:3.4.2

WORKDIR /app

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client vim

COPY Gemfile Gemfile.lock ./


RUN bundle install

COPY . .

EXPOSE 3000

CMD ["sh", "-c", "rm -f tmp/pids/server.pid && bin/rails tailwindcss:build && TAILWINDCSS_WATCHER=polling bin/rails tailwindcss:watch & bin/rails server -b 0.0.0.0"]
