# syntax=docker/dockerfile:1@sha256:b6afd42430b15f2d2a4c5a02b919e98a525b785b1aaff16747d2f623364e39b6

# ------------------------------
FROM golang:1.25-alpine@sha256:d3f0cf7723f3429e3f9ed846243970b20a2de7bae6a5b66fc5914e228d831bbb AS build

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
FROM golang:1.25-alpine@sha256:d3f0cf7723f3429e3f9ed846243970b20a2de7bae6a5b66fc5914e228d831bbb AS air

COPY --from=cosmtrek/air:latest@sha256:72a5cd981f3f5dfcba7264b28c0e963362d3d542e3462fea77ca5a5e98436697 /go/bin/air /usr/local/bin/air
COPY .air.toml .

CMD ["air"]
