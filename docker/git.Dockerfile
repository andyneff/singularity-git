FROM vsiri/recipe:git-lfs as git-lfs
FROM vsiri/recipe:vsi as vsi

###############################################################################

FROM debian:stretch-slim

SHELL ["/usr/bin/env", "bash", "-euxvc"]

# # Install any runtime dependencies
RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      ca-certificates less openssh-client tzdata vim \
      libc6 libcurl3-gnutls libexpat1 libpcre3 zlib1g perl liberror-perl; \
    rm -rf /var/lib/apt/lists/*

ARG GIT_VERSION=2.29.0
RUN DEPS="wget make autoconf gcc libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev asciidoc xmlto"; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${DEPS}; \
    wget "https://github.com/git/git/archive/v${GIT_VERSION}/git-${GIT_VERSION}.tar.gz"; \
    tar xvf git-${GIT_VERSION}.tar.gz; \
    pushd git-${GIT_VERSION}; \
      autoconf; \
      ./configure; \
      make -j $(nproc); \
      make install; \
    popd; \
    apt-get remove -y ${DEPS} --auto-remove; \
    rm -rf /var/lib/apt/lists/*

COPY --from=git-lfs /usr/local /usr/local
RUN git lfs install

ENV VSI_COMMON_DIR=/vsi

COPY --from=vsi /vsi /vsi

ADD ["git.env", "/src/"]

ENTRYPOINT ["/usr/bin/env", "bash", "/vsi/linux/just_files/just_entrypoint.sh", "git"]

CMD ["--help"]
