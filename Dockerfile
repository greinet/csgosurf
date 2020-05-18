FROM ubuntu:18.04
MAINTAINER Andreas Greiner <andreasgreiner@online.de>

ENV DIR_STEAM /steam
ENV DIR_STEAMCMD /steam/steamcmd
ENV DIR_CSGO /steam/csgo


RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install lib32gcc1 curl net-tools lib32stdc++6 python3 zip unzip wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd steam \
    && mkdir $DIR_STEAM \
    && mkdir $DIR_STEAMCMD \
    && mkdir $DIR_CSGO \
    && chown steam:steam $DIR_STEAM \
    && chown steam:steam $DIR_STEAMCMD \
    && chown steam:steam $DIR_CSGO

USER steam

# Install steamcmd
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"  | tar xz -C $DIR_STEAMCMD

WORKDIR $DIR_STEAMCMD

COPY --chown=steam:steam startup.sh $DIR_STEAMCMD/startup.sh

RUN chmod 777 $DIR_STEAMCMD/startup.sh

VOLUME $DIR_CSGO

ENTRYPOINT exec $DIR_STEAMCMD/startup.sh
#ENTRYPOINT /bin/sh

# Main gamestream
EXPOSE 27015/udp
# Clientport, no need to forward
EXPOSE 27005/udp
# SourceTV, forward so GOTV can be used
EXPOSE 27020/udp
