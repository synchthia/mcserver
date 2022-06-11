FROM docker.io/eclipse-temurin:17-alpine AS download_spigot
WORKDIR /spigot

ARG SERVER_VERSION=latest

RUN apk add --no-cache curl jq git
COPY utils/spigot.sh /spigot/

# Download spigot
RUN sh /spigot/spigot.sh $SERVER_VERSION
RUN java -jar BuildTools.jar --rev=${SERVER_VERSION} \
    && mv -v ./spigot-${SERVER_VERSION}.jar ./spigot.jar
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

# Install spigot
COPY --from=download_spigot /spigot/spigot.jar /spigot/

# Setup user
RUN chmod u+s /bin/*
RUN apk --no-cache add su-exec shadow yq

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
#CMD ["java", "-jar", "/spigot/spigot.jar", "-nogui"]
