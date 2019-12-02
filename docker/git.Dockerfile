FROM vsiri/recipe:gosu as gosu
FROM vsiri/recipe:tini-musl as tini
FROM vsiri/recipe:git-lfs as git-lfs
FROM vsiri/recipe:vsi as vsi

###############################################################################

FROM alpine:3.10

SHELL ["/usr/bin/env", "sh", "-euxvc"]

# Install any runtime dependencies
RUN apk add --no-cache \
      bash git less openssh tzdata

COPY --from=tini /usr/local /usr/local
COPY --from=git-lfs /usr/local /usr/local
RUN git lfs install
COPY --from=gosu /usr/local /usr/local
# Allow non-privileged to run gosu (remove this to take root away from user)
RUN chmod u+s /usr/local/bin/gosu

COPY --from=vsi /vsi /vsi
ADD ["git.env", "/src/"]

ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/bin/env", "bash", "/vsi/linux/just_entrypoint.sh", "git"]

CMD ["--help"]
