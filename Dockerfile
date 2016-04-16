FROM cnosuke/ruby23-base
MAINTAINER shinnosuke@gmail.com

RUN apt-get update
RUN apt-get install -y mysql-client libmysqlclient-dev
RUN mkdir -p /app /data /app/log /app/tmp
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN cd /app && bundle install --without development test --deployment --quiet

ADD app /app/app
ADD bin /app/bin
ADD config /app/config
ADD lib /app/lib
COPY config.ru /app/
COPY Rakefile /app/
COPY Schemafile /app/
COPY dot_env /app/.env
COPY .git/logs/HEAD /GIT_LOGS
RUN tail -1 /GIT_LOGS |awk '{print $2}' > /app/REVISION

EXPOSE 8080

CMD ["bundle", "exec", "unicorn", "-c", "/app/config/unicorn/production.rb"]
