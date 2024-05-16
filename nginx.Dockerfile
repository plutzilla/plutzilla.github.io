FROM nginx:1.25.5

COPY ./_site /usr/share/nginx/html
