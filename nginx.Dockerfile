FROM nginx:1.23.2

COPY ./_site /usr/share/nginx/html
