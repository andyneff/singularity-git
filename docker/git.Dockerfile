FROM vsiri/recipe:git-lfs as git-lfs
FROM vsiri/recipe:vsi as vsi

###############################################################################

FROM alpine:3.10

SHELL ["/usr/bin/env", "sh", "-euxvc"]

# # Install any runtime dependencies
RUN apk add --no-cache \
      bash git less openssh tzdata

COPY --from=git-lfs /usr/local /usr/local
RUN git lfs install

ENV VSI_COMMON_DIR=/vsi

COPY --from=vsi /vsi /vsi

ADD ["git.env", "/src/"]

ENTRYPOINT ["/usr/bin/env", "bash", "/vsi/linux/just_entrypoint.sh", "git"]

CMD ["--help"]
