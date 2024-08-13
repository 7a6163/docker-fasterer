FROM ruby:2-alpine AS builder

RUN apk add --no-cache build-base=0.5-r3 && gem install fasterer:0.11.0

FROM ruby:2-alpine

RUN apk add --no-cache tini=0.19.0-r0

COPY --from=builder /usr/local/bundle /usr/local/bundle

WORKDIR /app

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["fasterer"]
