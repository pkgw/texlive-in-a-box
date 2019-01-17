# Copyright 2019 Peter Williams
# Licensed under the MIT License.
#
# Build with something like `docker build --tag tlaib .`.

FROM alpine:edge
LABEL maintainer="peter@newton.cx"

VOLUME ["/work"]
WORKDIR /work
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

RUN apk update && \
    apk add \
        bash \
        sudo \
        texlive-full

COPY entrypoint.sh /
RUN ["/bin/chmod", "+x", "/entrypoint.sh"]
