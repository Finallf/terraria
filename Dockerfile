# syntax=docker/dockerfile:1

# STAGE 1: The Builder (Temporary Environment)
FROM debian:bookworm-slim AS builder

RUN set -eux \
&&  apt-get -qq update \
&&  apt-get -qq install --no-install-recommends \
    curl \
    unzip \
    ca-certificates

WORKDIR /tshock

ARG TSHOCK=https://github.com/Pryaxis/TShock/releases/download/v6.1.0/TShock-6.1.0-for-Terraria-1.4.5.6-linux-x64-Release.zip
    # Download TShock and extract the files:
RUN curl -SL $TSHOCK -o tshock.zip \
    && unzip -q tshock.zip -d /tshock \
    &&  tar -xf *.tar \
    &&  rm -rf tshock.zip *.tar

# STAGE 2: Use the official Microsoft image with the .NET 9 Runtime:
FROM mcr.microsoft.com/dotnet/runtime:9.0-bookworm-slim

LABEL Maintainer="Finallf <finallf2@gmail.com>"
LABEL Homepage="reloaded.com.br"
LABEL Description="Docker .NET 9 image to run a Terraria server with TShock."

# Environment Settings:
ENV WDIR=/tshock \
    UID=1000 \
    GID=0 \
    TZ=UTC \
    CONFIGPATH=/tshock/config \
    LOGPATH=/tshock/logs \
    CRASHDIR=/tshock/crashes \
    ADDITIONALPLUGINS=/tshock/plugins \
    WORLDPATH=/tshock/worlds \
    HOME=/tmp

# Copy the configuration files to the container:
COPY --from=builder --chown=$UID:$GID /tshock $WDIR
COPY --chown=$UID:$GID app/* /app/

# Define the working directory:
WORKDIR $WDIR

# Install the necessary extensions and dependencies:
RUN set -eux \
&&  apt-get -qq update \
&&	apt-get -qq install --no-install-recommends tzdata jq \
    # Creates folders to ensure permissions on volumes:
&&  mkdir -p $WORLDPATH $CONFIGPATH $LOGPATH $CRASHDIR $ADDITIONALPLUGINS \
    # Set the permissions so that files and folders can be accessed and executed by the non-root user:
&&  chown -R $UID:$GID /app $WDIR \
&&  chmod -R g+rwX /app $WDIR \
    # Make the entrypoint.sh script and TShock.Server binary executable:
&&  chmod +x /app/entrypoint.sh $WDIR/TShock.Server \
    # Cleaning the image:
&&  apt-get -qq clean \
&&  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

# Integrity verification:
HEALTHCHECK --interval=6m --timeout=30s --start-period=3m --retries=3 \
    CMD /bin/bash -c '</dev/tcp/127.0.0.1/7777' || exit 1

# Tell Docker that all future commands should be executed as this user:
USER $UID:$GID

# Expose the doors:
EXPOSE 7777 7878

# Check if a Terraria instance already exists:
ENTRYPOINT ["/app/entrypoint.sh"]