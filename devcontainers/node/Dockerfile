FROM node:24-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=C.UTF-8

USER root

RUN apt update -y && \
    apt install -y curl git sudo zstd make

ARG CONTAINER_USERNAME=node
ARG CONTAINER_USERID=1000

RUN install --owner=${CONTAINER_USERNAME} --directory /work && \
    echo "${CONTAINER_USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/container && \
    chmod 440 /etc/sudoers.d/container && \
    \
    apt clean && \
    rm -rf /var/log/* ; \
    rm -rf /tmp/*

USER ${CONTAINER_USERNAME}

RUN curl -fsSL https://raw.githubusercontent.com/pirakansa/ppkgmgr/main/install.sh | bash && \
    /home/${CONTAINER_USERNAME}/.local/bin/ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/codex.yml && \
    /home/${CONTAINER_USERNAME}/.local/bin/ppkgmgr dl https://raw.githubusercontent.com/pirakansa/bootkit/main/manifests/linux-x64/copilot-cli.yml && \
    echo "finished downloading packages"

WORKDIR /work