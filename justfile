_default:
  @just --list

alias b := build
[doc('docker build')]
build:
  @docker build . -f docker/Dockerfile --target api -t go_api:latest

alias s := serve
[doc('serve :8080 with air and ollama via docker compose')]
serve:
  @docker compose -f docker/compose.yaml up
