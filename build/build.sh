#!/bin/bash

docker run -v $(dirname "$(pwd)"):/site -e JEKYLL_ENV=production plutzilla/lescinskas.lt:jekyll build
sudo chown -R paulius:paulius ../_site
gulp -f ../gulpfile.js
docker build -t eu.gcr.io/lescinskas-lt/nginx-server:latest -t eu.gcr.io/lescinskas-lt/nginx-server:v4 -f ../nginx.Dockerfile ..
gcloud docker -- push eu.gcr.io/lescinskas-lt/nginx-server:latest
gcloud docker -- push eu.gcr.io/lescinskas-lt/nginx-server:v4
# TODO Deploy to k8s
# kubectl apply -f ./k8s/deploy-beta.yml
