ARG SYSTEM_IMAGE
FROM $SYSTEM_IMAGE AS system

# Install some tools and basic
# libs required by most software.
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        tini \
        openssl \
        openssh-client \
        ca-certificates \
        shadow \
        bash \
        coreutils \
        findutils \
        diffutils \
        procps \
        file \
        curl \
        gnupg \
        tar \
        wget \
        nano \
        git \
        rsync \
        libgcc \
        libstdc++ \
        # Some really widely used librariers head, with out approach this is better than to install in child images
        icu-libs \
        fontconfig \
        libpng \
        libjpeg-turbo \
        libwebp \
        libzip \
        libpq \
        libxml2 \
        libuv \
        freetype \
        && \
        rm -rf /var/cache/apk/*

RUN usermod --shell /bin/bash root

COPY /system/ /
COPY /system/etc/skel/ /root/

WORKDIR /root

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/bash"]

# Install mcc build tooling
FROM system AS build-tool

COPY /build-tool/ /