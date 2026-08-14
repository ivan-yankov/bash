# Test container for the bash command library.
#
# Goals:
#   - a clean system that has none of the developer's ~/.bash content
#   - the external tools the testable commands shell out to
#   - a non-root user with passwordless sudo, so the many `sudo` commands can
#     run unattended instead of blocking on a password prompt
ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive

# Tools the commands under test invoke. Kept deliberately small: anything not
# listed here belongs to a command that is not covered by automated tests.
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash \
      coreutils \
      findutils \
      diffutils \
      grep \
      gawk \
      sed \
      perl-base \
      tar \
      gzip \
      zip \
      unzip \
      rsync \
      file \
      git \
      sudo \
      ca-certificates \
      python3 \
      shellcheck \
    && rm -rf /var/lib/apt/lists/*

# Ubuntu 24.04 ships an "ubuntu" user at uid 1000 that would collide with the
# test user, so remove it when present before creating ours.
RUN userdel -r ubuntu 2>/dev/null || true; \
    useradd --create-home --shell /bin/bash tester && \
    echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester && \
    chmod 0440 /etc/sudoers.d/tester

USER tester
WORKDIR /repo

# The suite writes fixtures into temporary directories, never into the repo,
# so the repo itself can be mounted read-only by the runner.
ENV TMPDIR=/tmp
ENV BASH_LOCAL=/home/tester/.bash
RUN mkdir -p /home/tester/.bash

CMD ["./test/runner.sh"]
