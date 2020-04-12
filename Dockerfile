FROM ruby:2.7
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV GIT_SSH_COMMAND="ssh -i /app/.ssh/\$GIT_IDENTITY_FILE -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
RUN bundle install
COPY . /app
RUN rm -rf /app/config/credentials.yml.enc
RUN EDITOR=vim rails credentials:edit
RUN rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
EXPOSE 3000

CMD rails db:migrate && rails server -e production -p 3000
