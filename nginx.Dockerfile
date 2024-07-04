FROM nginx:1.26.1

COPY ./_site /usr/share/nginx/html
