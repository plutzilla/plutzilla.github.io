FROM nginx:1.25.2

COPY ./_site /usr/share/nginx/html
