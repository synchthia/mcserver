FROM docker.io/alpine:latest AS download_paper
WORKDIR /paper

ARG PAPER_SPIGOT_VERSION=latest

RUN apk add --no-cache curl jq
COPY utils/paper.sh /paper/

# Download paper
RUN sh /paper/paper.sh $PAPER_SPIGOT_VERSION
# ---
# ---
FROM docker.io/eclipse-temurin:17
EXPOSE 25565
ENV LANG en_US.UTF-8

# Config
ENV SERVER_NAME unknown
ENV SERVER_ID unknown
ENV WHITE_LIST false
ENV ONLINE_MODE true
ENV PORT 25565

# Install paper
COPY --from=download_paper /paper/paper.jar /paper/

# Setup user
# RUN chmod u+s /bin/* && \
#     apk --no-cache add su-exec shadow yq

RUN apt-get update -qq && \
    apt-get install -y gosu && \
    apt-get clean

RUN curl -fsSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.34.1/yq_linux_amd64 && \
    chmod a+x /usr/local/bin/yq

# Copy Entry point
COPY entrypoint.sh launcher.sh autoconfig.sh /

RUN addgroup --gid 1000 app && \
    useradd app --uid 1000 -g app -s /bin/bash

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
