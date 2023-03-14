FROM --platform=linux/amd64 ruby:3.0.3

# yarn is for webpacker ... yarn stuff here was taken from a post on
# https://www.plymouthsoftware.com/articles/dockerising-webpacker/

RUN apt-get update -qq && \
    apt-get install -yq --no-install-recommends && \
    apt-get install -y nodejs
#    git \
#    build-essential \
#    less \
#    git \
#  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add Yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Update
RUN apt-get update -y

# Install Yarn
RUN apt-get install yarn -y

#ENV LANG=C.UTF-8 \
#  BUNDLE_JOBS=4 \
#  BUNDLE_RETRY=3
  
WORKDIR /usr/src/app
COPY Gemfile* .

#RUN gem update --system && \
#    gem install bundler -v 2.2.32 && \
#    bundle install 
    #gem install rails -v 7.0.4

RUN bundle install && \
    gem install rails -v 7.0.4

COPY . .
COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
