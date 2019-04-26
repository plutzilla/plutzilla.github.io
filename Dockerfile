FROM ruby:2.5-alpine

RUN apk add --no-cache build-base gcc bash cmake git

RUN gem install bundler
RUN gem install jekyll

EXPOSE 4000

WORKDIR /site

CMD ["bundle", "exec", "jekyll", "serve", "--drafts", "--watch", "--incremental", "-H", "0.0.0.0", "-P", "4000"]