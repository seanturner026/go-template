# go-template

Quick template for golang focusing on local development.

Uses [justfile](https://just.systems/man/en/) to run [air](https://github.com/air-verse/air) for hot reloading in with
docker compose.

Change names in two files and run `just serve` to start

```fish
# rg is ripgrep https://github.com/BurntSushi/ripgrep
$ rg go_api
justfile
7:  @docker build . -f docker/Dockerfile --target api -t go_api:latest

docker/compose.yaml
4:    image: go_api:air

$ rg app_user
docker/Dockerfile
6:RUN addgroup -S app_user && \
7:      adduser -S -u 1000 -g app_user app_user
32:USER app_user
```
