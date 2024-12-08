FROM nginx:1.26.2

COPY ./_site /usr/share/nginx/html
