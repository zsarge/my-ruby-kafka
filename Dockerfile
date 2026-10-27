FROM golang:1.24-alpine AS tester-build

ARG TESTER_REF=548089cf5b930d29a57e9fc4f6aa38bae336b158

RUN apk add --no-cache git \
    && git clone https://github.com/codecrafters-io/kafka-tester.git /src \
    && git -C /src checkout "$TESTER_REF" \
    && test "$(git -C /src rev-parse HEAD)" = "$TESTER_REF" \
    && cd /src \
    && CGO_ENABLED=0 go build -o /kafka-tester ./cmd/tester

FROM ruby:3.4-alpine

COPY --from=tester-build /kafka-tester /usr/local/bin/kafka-tester

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/kafka-tester"]
