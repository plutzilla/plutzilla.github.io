# Synopsis

This repository is a content for my personal weblog: http://lescinskas.lt

The site is generated using [Jekyll](http://jekyllrb.com).

You can use all the content of this weblog, as long as it meets [Creative Commons Attribution](https://creativecommons.org/licenses/by/4.0/) license.

# Build

## Docker build

Docker container can be used both to build the site and serve the content while composing blogposts.
Prerequisites: `docker-ce`, `docker-compose`.

Building the docker image:
```
$ cd /path/to/cloned/repo
$ docker-compose build
```

Building the static site:
```
$ docker run -v $(pwd):/site -e JEKYLL_ENV=production plutzilla/lescinskas.lt:jekyll build -s src -d _site
```

Starting the local server to watch changes while editing the content:
```
$ docker-compose up
```
The container listens to 4000 port which is forwarded to `localhost:8080`

## Manual build

The content is generated with [Jekyll](http://jekyllrb.com).
```
$ gem install jekyll
$ JEYLL_ENV=production budle exec jekyll build -s src -d _site
```

## Deployment

The site is deployed in Kubernetes cluster on Google Kubernetes Engine using [Drone](https://www.drone.io) as the CI/CD runner.
Please see the [build pipeline](.drone.yml) for more details.

Please share your feedback via email: paulius.lescinskas@gmail.com
