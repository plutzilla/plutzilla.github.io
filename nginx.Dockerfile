FROM nginx:1.25.1

COPY ./_site /usr/share/nginx/html
