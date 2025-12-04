# syntax=docker/dockerfile:1@sha256:b6afd42430b15f2d2a4c5a02b919e98a525b785b1aaff16747d2f623364e39b6

# ------------------------------
FROM golang:1.25-alpine@sha256:26111811bc967321e7b6f852e914d14bede324cd1accb7f81811929a6a57fea9 AS build

RUN addgroup -S app_user && \
	adduser -S -u 1000 -g app_user app_user

WORKDIR /app
COPY go.mod go.sum ./

RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	go mod download && \
	go mod verify

# https://stackoverflow.com/a/22276273/6004338
COPY . .
RUN --mount=type=cache,target=/go/pkg/mod \
	--mount=type=cache,target=/root/.cache/go-build \
	go build -ldflags="-w -s" -o api ./cmd/api

# -----------------
FROM scratch AS api

# Copy user and SSL Certificates from build
# Certificates needed to prevent x509 unknown authority errors
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /app/api /usr/local/bin/api
USER app_user

ENTRYPOINT ["/usr/local/bin/api"]

# ----------------------------
FROM golang:1.25-alpine@sha256:26111811bc967321e7b6f852e914d14bede324cd1accb7f81811929a6a57fea9 AS air

COPY --from=cosmtrek/air:latest@sha256:3def16c884b2b9409a4c7bb987cd76d656a12d0e0436fe8c583df93014e0356c /go/bin/air /usr/local/bin/air
COPY .air.toml .

CMD ["air"]
