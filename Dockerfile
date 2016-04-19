FROM cnosuke/ruby23-base
MAINTAINER shinnosuke@gmail.com

RUN apt-get update
RUN apt-get install -y mysql-client libmysqlclient-dev
RUN mkdir -p /app /data /app/log /app/tmp
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN cd /app && bundle install --without development test --deployment --quiet

WORKDIR /app
ADD app /app/app
ADD bin /app/bin
ADD config /app/config
ADD public /app/public
ADD lib /app/lib
COPY config.ru /app/
COPY Rakefile /app/
COPY Schemafile /app/
COPY .git/logs/HEAD /GIT_LOGS
RUN tail -1 /GIT_LOGS |awk '{print $2}' > /app/REVISION

RUN touch /app/.env

RUN bundle exec rake assets:precompile

EXPOSE 8080

CMD ["bundle", "exec", "unicorn", "-c", "/app/config/unicorn/production.rb", "-E", "production"]


# How to DB migrate
# docker-compose run -e RAILS_ENV=production --rm funho bundle exec rake ridgepole:apply

#bundle exec unicorn -c /app/config/unicorn/production.rb -E production
