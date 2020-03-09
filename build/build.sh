#!/bin/bash

sudo rm -rf ../_site

docker run -v $(dirname "$(pwd)"):/site -e JEKYLL_ENV=production plutzilla/jekyll:latest build -s src -d _site
docker run -v $(dirname "$(pwd)"):/site -w /site node:13 /bin/bash -c "npm install; npx gulp;"

#sudo chown -R paulius:paulius ../_site

docker build -t eu.gcr.io/lescinskas-lt/nginx-server:latest -t eu.gcr.io/lescinskas-lt/nginx-server:v13 -f ../nginx.Dockerfile ..
docker push eu.gcr.io/lescinskas-lt/nginx-server:latest
docker push eu.gcr.io/lescinskas-lt/nginx-server:v13
# TODO Deploy to k8s
# kubectl apply -f ./k8s/deploy-beta.yml
# kubectl apply -f ./k8s/deploy-www.yml
