# syntax=docker/dockerfile:1.7
# Pin the Alpine release in the tag (not the apk package revisions):
# Alpine repos only keep the latest revision of each package, so exact
# version pins break within weeks. A pinned Alpine release keeps the
# package set stable while still receiving security updates.
FROM python:3-alpine3.22

COPY requirements.txt /
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=cache,target=/root/.cache/pip \
    set -eux \
 && apk update \
 && apk add git \
 && apk add --virtual .build-deps \
    make \
    gcc \
    libc-dev \
    openssl-dev \
    libffi-dev \
 && PIP_CACHE_DIR=/root/.cache/pip pip install -r requirements.txt \
 && runDeps="$( \
      scanelf --needed --nobanner --recursive /usr/local \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r apk info --installed \
      | sort -u \
    )" \
 && apk add --virtual .ansible-lint-rundeps $runDeps \
 && apk del .build-deps

RUN ansible-galaxy collection install theforeman.foreman
RUN ansible-galaxy collection install ansible.posix

ENV ANSIBLE_LOCAL_TEMP=/tmp
WORKDIR /work
CMD ["ansible-lint", "--help"]
