FROM ruby:3-alpine AS builder

# Define versions as build arguments
ARG FASTERER_VERSION=0.11.0
ARG REVIEWDOG_VERSION=0.20.3
ARG BUILD_BASE_VERSION=0.5-r3

RUN apk add --no-cache build-base=${BUILD_BASE_VERSION} && \
    gem install fasterer:${FASTERER_VERSION}

# Add reviewdog installation
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | \
    sh -s -- -b /usr/local/bin/ v${REVIEWDOG_VERSION}

FROM ruby:3-alpine

# Pass versions to the final image
ARG TINI_VERSION=0.19.0-r3

RUN apk add --no-cache tini=${TINI_VERSION}

# Copy reviewdog binary from builder stage
COPY --from=builder /usr/local/bin/reviewdog /usr/local/bin/reviewdog
COPY --from=builder /usr/local/bundle /usr/local/bundle

WORKDIR /app

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["fasterer"]
