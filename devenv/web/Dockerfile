FROM cimg/ruby:3.1.0-browsers
RUN sudo apt-get update -qq && sudo apt-get install -y build-essential libpq-dev curl apt-transport-https git libssl-dev imagemagick libmagickwand-dev zlib1g-dev unzip

RUN curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list

RUN sudo apt-get update -y && sudo apt-get install -y google-chrome-stable
RUN sudo apt-get install -y graphviz

RUN cd /tmp && \
    wget -N http://chromedriver.storage.googleapis.com/100.0.4896.20/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && sudo mv chromedriver /usr/local/bin
#RUN mkdir /myapp
#WORKDIR /myapp
COPY Gemfile /home/circleci/Gemfile
COPY Gemfile.lock /home/circleci/Gemfile.lock
COPY . /home/circleci


ENV LANG C.UTF-8
