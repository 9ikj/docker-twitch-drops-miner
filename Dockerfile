# Pull base image.
FROM jlesage/baseimage-gui:debian-12-v4.7

LABEL org.opencontainers.image.authors="admin@9ikj.cn"
ARG COMMIT_ID

# Environment
ENV LANG=en_US.UTF-8
ENV KEEP_APP_RUNNING=1
ENV TDM_VERSION_TAG ${COMMIT_ID}
ENV APP_ICON_URL https://raw.githubusercontent.com/DevilXD/TwitchDropsMiner/master/appimage/pickaxe.png

# Install Twitch Drops Miner
RUN apt-get update -y
RUN apt-get install -y curl wget unzip libc6 gir1.2-ayatanaappindicator3-0.1 locales fonts-noto-color-emoji fonts-wqy-zenhei
RUN wget -P /tmp/ https://github.com/DevilXD/TwitchDropsMiner/releases/download/dev-build/Twitch.Drops.Miner.Linux.PyInstaller.zip
RUN mkdir /TwitchDropsMiner
RUN unzip -p /tmp/Twitch.Drops.Miner.Linux.PyInstaller.zip "Twitch Drops Miner/Twitch Drops Miner (by DevilXD)" >/TwitchDropsMiner/TwitchDropsMiner
RUN chmod +x /TwitchDropsMiner/TwitchDropsMiner
RUN rm -rf /tmp

# Link config folder files
RUN mkdir /TwitchDropsMiner/config

RUN ln -s /TwitchDropsMiner/config/settings.json /TwitchDropsMiner/settings.json
RUN ln -s /TwitchDropsMiner/config/cookies.jar /TwitchDropsMiner/cookies.jar

# Make sure permissions are gonna work
RUN chmod -R 777 /TwitchDropsMiner

# Copy the start script.
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Generate and install favicons
RUN install_app_icon.sh "$APP_ICON_URL"

# Set the name/version of the application.
RUN set-cont-env APP_NAME "Twitch Drops Miner"
RUN set-cont-env APP_VERSION "$TDM_VERSION_TAG"
