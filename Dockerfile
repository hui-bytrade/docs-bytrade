FROM ruby:2.6.3   AS builder
WORKDIR /buildc
COPY . ./
RUN gem install bundler && \
    wget https://nodejs.org/download/release/v16.2.0/node-v16.2.0-linux-x64.tar.gz && \
    tar -zxvf node-v16.2.0-linux-x64.tar.gz  && \
    ln -s /buildc/node-v16.2.0-linux-x64/bin/node /usr/bin/node && \
    bundle install && \
    bundle exec middleman build --clean --build-dir test-en


FROM openresty/openresty:buster-fat
COPY --from=builder /buildc/test-en  /usr/local/openresty/nginx/html
