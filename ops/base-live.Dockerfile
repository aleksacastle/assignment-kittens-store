FROM ruby:2.4.9-alpine as GEM
ENV BUNDLER_VERSION=2.2.23
RUN apk add --update --no-cache \
    build-base=~0.5 \
    postgresql-dev=~12 \
    && gem install bundler -v $BUNDLER_VERSION
COPY Gemfile Gemfile.lock /app/
WORKDIR /app


RUN bundle install --no-cache


FROM ruby:2.4.9-alpine

RUN apk add --update --no-cache postgresql-client
COPY --from=GEM /usr/local/bundle/ /usr/local/bundle/

COPY . /app/

ENTRYPOINT ['bundle', 'exec']
CMD 'rackup'
