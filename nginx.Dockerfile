FROM nginx:1.27.3

COPY ./_site /usr/share/nginx/html
