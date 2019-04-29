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
$ cd /path/to/
$ docker build -t plutzilla/lescinskas.lt:jekyll .
```

Building the static site:
```
$ docker run -v $(pwd):/site plutzilla/lescinskas.lt:jekyll build
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
$ jekyll build
```

## Deployment

I use [Gulp](http://gulpjs.com/) to build, compress and release the site to production. You can refer to [gulpfile.js](gulpfile.js).

Please share your feedback via email: paulius.lescinskas@gmail.com
