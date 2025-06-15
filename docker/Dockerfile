FROM ruby:3.1-alpine as builder
# First build the static site with jekyll
WORKDIR /srv/jekyll/

RUN set -eux; \
    apk add --no-cache --virtual build-deps \
        build-base \
        zlib-dev \
    ;

COPY --chown=jekyll:jekyll ./Gemfile .
COPY --chown=jekyll:jekyll ./Gemfile.lock .
RUN gem install bundler && bundler install

COPY --chown=jekyll:jekyll ./ .
RUN bundle exec jekyll build
RUN ls -alhn

# Then place the built static site on webserver
FROM httpd:alpine

WORKDIR /usr/local/apache2/htdocs/

COPY --from=builder /srv/jekyll/_site .

EXPOSE 80