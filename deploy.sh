#!/bin/bash

docker run -v $(pwd):/site -e JEKYLL_ENV=production plutzilla/lescinskas.lt:jekyll build
sudo chown -R paulius:paulius ./_site
gulp release
