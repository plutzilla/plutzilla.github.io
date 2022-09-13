FROM nginx:1.23.1

COPY ./_site /usr/share/nginx/html
