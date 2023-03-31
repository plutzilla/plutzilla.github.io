FROM nginx:1.23.3

COPY ./_site /usr/share/nginx/html
