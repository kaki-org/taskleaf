FROM ruby:2.6.5-slim
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl apt-transport-https git libssl-dev imagemagick libmagickwand-dev zlib1g-dev unzip


RUN curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_6.x xenial main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update -qq && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

RUN curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

RUN apt-get update -y && apt-get install -y google-chrome-stable
RUN apt-get install -y graphviz

RUN cd /tmp && \
    wget -N http://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && mv chromedriver /usr/local/bin
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
RUN rails webpacker:install
RUN yarn cache clean && yarn install
COPY . /myapp


ENV LANG C.UTF-8
