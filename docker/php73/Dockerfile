ARG BASE_IMAGE



### [Stage 1] Build the component artifacts

FROM $BASE_IMAGE AS component-begin

RUN mcc component-begin node

ARG PHP_VERSION="7.3.6-r0"
ARG PHP_APCU_VERSION="5.1.17-r1"
ARG PHP_IMAGICK_VERSION="3.4.4-r1"

ENV PHP_VERSION="$PHP_VERSION"

# Install PHP and the most common extensions.
# Do not install php-gd moduel as it pulls half of X11 and related libraries...
# For this we can use a separate image, probably rarely used in cli.
RUN apk add --no-cache \
        php7=${PHP_VERSION} \
        php7-opcache=${PHP_VERSION} \
        php7-intl=${PHP_VERSION} \
        php7-json=${PHP_VERSION} \
        php7-mbstring=${PHP_VERSION} \
        php7-simplexml=${PHP_VERSION} \
        php7-dom=${PHP_VERSION} \
        php7-bcmath=${PHP_VERSION} \
        php7-curl=${PHP_VERSION} \
        php7-openssl=${PHP_VERSION} \
        php7-sqlite3=${PHP_VERSION} \
        php7-pcntl=${PHP_VERSION} \
        php7-zip=${PHP_VERSION} \
        php7-bz2=${PHP_VERSION} \
        php7-ftp=${PHP_VERSION} \
        php7-pdo=${PHP_VERSION} \
        php7-pdo_mysql=${PHP_VERSION} \
        php7-pdo_sqlite=${PHP_VERSION} \
        php7-pdo_pgsql=${PHP_VERSION} \
        php7-exif=${PHP_VERSION} \
        php7-pecl-apcu=${PHP_APCU_VERSION} \
        && \
    rm -rf /var/cache/apk/*



### [Stage 2] Install clean component artifact fs to intermediary dir

FROM component-begin AS component-finish

RUN mcc component-finish node



### [Stage 3] Create a clean component fs without anything else

FROM scratch AS component

COPY --from=component-finish /component/node/rootfs/ /



### [Stage 4] Create a final runnable image with the component

FROM $BASE_IMAGE

COPY --from=component / /

