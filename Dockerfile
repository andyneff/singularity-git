FROM vsiri/recipe:git-lfs as git-lfs
FROM vsiri/recipe:vsi as vsi

###############################################################################

FROM debian:stretch-slim

SHELL ["/usr/bin/env", "bash", "-euxvc"]

# # Install any runtime dependencies
RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      ca-certificates git less openssh-client tzdata; \
    rm -rf /var/lib/apt/lists/*

COPY --from=git-lfs /usr/local /usr/local
RUN git lfs install

ENV VSI_COMMON_DIR=/vsi

COPY --from=vsi /vsi /vsi

ADD ["git.env", "/src/"]

ENTRYPOINT ["/usr/bin/env", "bash", "/vsi/linux/just_entrypoint.sh", "git"]

CMD ["--help"]
