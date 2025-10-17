#!/usr/bin/env bash

docker build -t php-test --build-arg APP_ENV=dev .
docker run --rm -p 8080:8080 -v "$PWD":/var/www/html php-test