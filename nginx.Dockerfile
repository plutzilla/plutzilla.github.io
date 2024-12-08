FROM nginx:1.26.0

COPY ./_site /usr/share/nginx/html
