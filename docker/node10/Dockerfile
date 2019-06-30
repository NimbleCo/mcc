### [Stage 1] Build the component artifacts

ARG BASE_IMAGE

FROM $BASE_IMAGE AS component-begin

RUN mcc component-begin node10

ARG NODE_VERSION="10.16.0-r0"
ARG YARN_VERSION="1.16.0-r0"

ENV NODE_VERSION="$NODE_VERSION" \
    YARN_VERSION="$YARN_VERSION"

RUN apk add --no-cache \
        nodejs=${NODE_VERSION} \
        yarn=${YARN_VERSION} && \
    rm -rf /var/cache/apk/*



### [Stage 2] Install clean component artifact fs to intermediary dir

FROM component-begin AS component-finish

RUN mcc component-finish node10



### [Stage 3] Create a clean component fs without anything else

FROM scratch AS component

COPY --from=component-finish /component/node10/rootfs/ /



### [Stage 4] Create a final runnable image with the component

FROM $BASE_IMAGE

COPY --from=component / /

