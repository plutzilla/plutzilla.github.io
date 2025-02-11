FROM nginx:1.27.4

COPY ./_site /usr/share/nginx/html
