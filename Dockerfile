FROM alpine:3.12

ARG nginx_version=1.19.3

RUN apk add --no-cache \
        pcre \
        zlib \
        libressl && \
    apk add --no-cache --virtual .build \
        build-base \
        curl \
        git \
        pcre-dev \
        zlib-dev \
        libressl-dev && \
    cd /tmp && \
    curl -L0 http://nginx.org/download/nginx-${nginx_version}.tar.gz -o nginx.tar.gz && \
    tar xvf nginx.tar.gz && \
    cd nginx-${nginx_version} && \
    ls -lh && \
    git clone https://github.com/anomalizer/ngx_aws_auth.git && \
    ./configure \
        --with-http_ssl_module \
        --add-module=ngx_aws_auth && \
    make install && \
    cd /tmp && \
    rm -rf nginx-${nginx_version} && \
    apk del --purge .build

CMD [ "/usr/local/nginx/sbin/nginx", "-c", "/nginx.conf" ]