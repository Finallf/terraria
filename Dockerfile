# syntax=docker/dockerfile:1

# STAGE 1: The Builder (Temporary Environment)
FROM debian:13-slim AS builder

ARG TSHOCK=https://github.com/Pryaxis/TShock/releases/download/v6.1.0/TShock-6.1.0-for-Terraria-1.4.5.6-linux-x64-Release.zip
ARG RUNTIME=https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-linux-x64.tar.gz

ENV WDIR=/tshock

RUN set -eux \
&&  apt-get -qq update \
&&  apt-get -qq install --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
&&  mkdir -p $WDIR /dotnet \
&&  curl -sSL \
    $TSHOCK -o tshock.zip \
    $RUNTIME -o runtime.tar.gz \
&&  unzip -q tshock.zip -d $WDIR \
&&  tar -xf $WDIR/*.tar -C $WDIR \
&&  tar -zxf runtime.tar.gz -C /dotnet --no-same-owner \
&&  rm -rf tshock.zip $WDIR/*.tar runtime.tar.gz

COPY app/ /app/

# Read/write/execute permission for the group (g+rwX), preserved in the COPY of Stage 2.
RUN set -eux \
&&  mkdir -p $WDIR/worlds $WDIR/config $WDIR/logs $WDIR/crashes $WDIR/plugins \
&&  chmod -R g+rwX $WDIR /dotnet /app \
&&  chmod +x /app/entrypoint.sh $WDIR/TShock.Server

# STAGE 2: Final Image (Debian 13 Trixie Slim)
FROM debian:13-slim

LABEL Maintainer="Finallf <finallf2@gmail.com>"
LABEL Homepage="reloaded.com.br"
LABEL Description="Custom Debian 13 image with .NET 10 Runtime for TShock/Terraria."

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
    HOME=/tmp \
    DOTNET_ROOT=/usr/share/dotnet \
    PATH=$PATH:/usr/share/dotnet \
    DEBIAN_FRONTEND=noninteractive

# Install the necessary extensions and dependencies:
RUN set -eux \
&&  apt-get -qq update \
&&  apt-get -qq install --no-install-recommends \
    ca-certificates \
    jq \
    libicu76 \
    libssl3t64 \
    tzdata \
    zlib1g \
    # Creates the symbolic link for dotnet/runtime:
&&  ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    # Cleaning the image:
&&  apt-get -qq clean \
&&  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

# Copy the files, setting the permissions so that they can be accessed and executed by the non-root user:
COPY --from=builder --chown=$UID:$GID /tshock $WDIR
COPY --from=builder --chown=$UID:$GID /app /app
COPY --from=builder /dotnet /usr/share/dotnet

WORKDIR $WDIR
USER $UID:$GID

HEALTHCHECK --interval=6m --timeout=30s --start-period=3m --retries=3 \
    CMD /bin/bash -c '</dev/tcp/127.0.0.1/7777' || exit 1

EXPOSE 7777 7878
ENTRYPOINT ["/app/entrypoint.sh"]