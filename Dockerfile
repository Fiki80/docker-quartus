FROM debian:buster-slim AS base

ARG uid 
ARG gid

RUN set -eux && \
	apt-get -y update && \
    apt-get install -y --no-install-recommends \
		libgtk2.0-0 libgtk-3-0 libx11-xcb1 libx11-6 libxrender1 libusb-0.1-4 \
		libc6-i386 libncurses6 libxtst6 libxft2 libstdc++6 libc6-dev lib32z1 \
		libncurses5 libbz2-1.0 libpng16-16 libsm6 && \
	apt-get autoclean && apt-get clean && apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists

RUN grep -q ${gid} /etc/group || groupadd -g ${gid} altera
RUN useradd -u ${uid} -g ${gid} -m altera
# RUN mkdir /var/run/dbus
        
FROM base AS quartus-temp

# ARG filename

ADD *.run /setup/
ADD *.qdz /setup/

RUN /setup/QuartusLiteSetup*.run \
		--mode unattended \
		--unattendedmodeui none \
		--installdir /opt/quartus_lite \
		--accept_eula 1
	
FROM base
COPY --from=quartus-temp /opt/quartus_lite /opt/quartus_lite

ENV PATH "$PATH:/opt/quartus_lite/quartus/bin"

CMD ["quartus", "--64bit"]

# libasound2 libcairo2 libgl1-mesa-glx \
# libdbus-1-3 libnss3 libnspr4 \
# libxss1 \
# libgconf-2-4 libpython2.7 libtinfo5


