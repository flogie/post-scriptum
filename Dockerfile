############################################################
# Dockerfile that builds a Post Scriptum Gameserver
############################################################
FROM cm2network/steamcmd:steam

LABEL maintainer="flo.gierer@gmail.com"

ENV STEAMAPPID 746200
ENV STEAMAPPDIR /home/steam/post-scriptum-dedicated

# Run Steamcmd and install Squad
RUN set -x \
	&& "${STEAMCMDDIR}/steamcmd.sh" \
		+login anonymous \
		+force_install_dir ${STEAMAPPDIR} \
		+app_update ${STEAMAPPID} validate \
		+quit

ENV PORT=7787 \
	QUERYPORT=27165 \
	RCONPORT=21114 \
	FIXEDMAXPLAYERS=80 \
	RANDOM=NONE

WORKDIR $STEAMAPPDIR

VOLUME $STEAMAPPDIR

# Set Entrypoint
# 1. Update server
# 2. Start server
ENTRYPOINT ${STEAMCMDDIR}/steamcmd.sh \
		+login anonymous +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} +quit \
		&& ${STEAMAPPDIR}/PostScriptumServer.sh \
			Port=$PORT QueryPort=$QUERYPORT RCONPORT=$RCONPORT FIXEDMAXPLAYERS=$FIXEDMAXPLAYERS RANDOM=$RANDOM

# Expose ports
EXPOSE 7787/udp \
	27165/tcp \
	27165/udp \
	21114/tcp \
	21114/udp

