FROM docker.io/alpine:latest AS download_paper
WORKDIR /paper

RUN apk add --no-cache curl jq
COPY utils/paper.sh /paper/

# Download paper
RUN sh /paper/paper.sh 1.18
# ---
# ---
FROM docker.io/eclipse-temurin:17-alpine
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
RUN chmod u+s /bin/*
RUN apk --no-cache add su-exec shadow yq tmux

# Copy Entry point
COPY entrypoint.sh starter.sh autoconfig.sh /

RUN addgroup -g 1000 app && \
    adduser app -u 1000 -S -G app

# Copy basements...
COPY server/ /app/server/
COPY config/ /app/config/
COPY plugins/ /app/plugins/
COPY worlds/ /app/worlds/

WORKDIR /app/server

CMD ["sh", "/entrypoint.sh"]
#CMD ["java", "-jar", "/paper/paper.jar", "-nogui"]
