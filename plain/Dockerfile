FROM docker.io/alpine:latest AS download_assets

ARG PAPER_SPIGOT_VERSION=latest
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache curl jq
COPY utils/paper.sh /paper/

# Download tools
WORKDIR /tmp
RUN wget -O packy.tar.gz https://github.com/synchthia/packy/releases/latest/download/packy_${TARGETOS}_${TARGETARCH}.tar.gz && \
    tar -xvzf ./packy.tar.gz && \
    wget -O yq https://github.com/mikefarah/yq/releases/latest/download/yq_${TARGETOS}_${TARGETARCH} && \
    chmod +x yq

# Download paper
WORKDIR /paper
RUN sh /paper/paper.sh $PAPER_SPIGOT_VERSION

# ---
# ---
FROM docker.io/eclipse-temurin:21
EXPOSE 25565

ENV LANG=en_US.UTF-8

# Config
ENV SERVER_NAME=unknown
ENV SERVER_ID=unknown
ENV WHITE_LIST=false
ENV ONLINE_MODE=true
ENV PORT=25565

# Install assets
COPY --from=download_assets /tmp/packy /tmp/yq /usr/local/bin/

# Install paper
COPY --from=download_assets /paper/paper.jar /paper/

# Setup user
# RUN chmod u+s /bin/* && \
#     apk --no-cache add su-exec shadow yq

RUN apt-get update -qq && \
    apt-get install -y gosu && \
    apt-get clean

# Copy Entry point
COPY entrypoint.sh launcher.sh autoconfig.sh /

RUN useradd app --uid 7000 -U -s /bin/bash

# Copy basements...
COPY templates/ /app/templates/
COPY server/ /app/server/

# Create internal directories
# Make symbolic link (for compatibility)
RUN mkdir -p \
    /app/config \
    /app/plugins \
    /app/worlds \
    && ln -sfnv /app/plugins /app/server/plugins

WORKDIR /app/server

CMD ["bash", "/entrypoint.sh"]
#CMD ["java", "-jar", "/paper/paper.jar", "-nogui"]
