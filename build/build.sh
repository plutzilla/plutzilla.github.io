#!/bin/bash

sudo rm -rf ../_site

docker run -v $(dirname "$(pwd)"):/srv/jekyll -e JEKYLL_ENV=production jekyll/minimal:4 jekyll build -s src -d _site
docker run -v $(dirname "$(pwd)"):/site -w /site node:13 /bin/bash -c "npm install; npx gulp;"

#sudo chown -R paulius:paulius ../_site

docker build -t plutzilla/lescinskas.lt:latest -f ../nginx.Dockerfile ..
docker push plutzilla/lescinskas.lt:latest

# Deploy to k8s using Helm from /deploy/helm
