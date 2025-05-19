FROM node:18-bullseye

# Install steamcmd
ARG DEBIAN_FRONTEND=noninteractive
RUN sed -i -e 's/debian bullseye main/debian bullseye main non-free/' /etc/apt/sources.list \
    && { echo steam steam/question select "I AGREE" | debconf-set-selections ; } \
    && { echo steam steam/license note "" | debconf-set-selections ; } \
    && dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install --no-install-recommends -y locales steamcmd \
    && sed -i -e 's/# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen \
    && locale-gen

# Install steamcmd-app-update
RUN npm install -g  git+https://github.com/manicmou/steamcmd-app-update.git

WORKDIR /steam
COPY entrypoint.sh ./

## Change the following at runtime
# ... variables for steamcmd-app-update
ENV STEAM_API_KEY= STEAM_PROFILE_ID= SKIP_GAMES= FORCE_VALIDATE= STEAM_API_TOKEN= STEAM_FAMILY_ID=
# ... variables for steamcmd. Note: default platform is windows
# Possible platforms: linux, windows, macos
ENV STEAM_USERNAME= STEAM_PASSWORD= STEAM_PLATFORM=windows

# Don't change
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en

VOLUME ["/steam/.steam"]
ENTRYPOINT ["./entrypoint.sh"]
CMD ["+runscript", "/steam/commands.txt"]
