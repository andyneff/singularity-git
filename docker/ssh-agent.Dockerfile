FROM vsiri/recipe:vsi as vsi

###############################################################################

FROM debian:stretch-slim

SHELL ["/usr/bin/env", "bash", "-euxvc"]

# # Install any runtime dependencies
RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      openssh-client tzdata; \
    rm -rf /var/lib/apt/lists/*

ENV VSI_COMMON_DIR=/vsi
COPY --from=vsi /vsi /vsi

ADD ["git.env", "/src/"]

ENTRYPOINT ["/usr/bin/env", "bash", "/vsi/linux/just_entrypoint.sh"]

CMD ["bash", "-c", "ssh-agent -D -a ${GIT_SSH_AGENT_ADDRESS}"]
