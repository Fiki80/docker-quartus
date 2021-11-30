FROM centos:7

ARG uid 
ARG gid

RUN set -eux && \
	yum update -y && \
    yum install -y \
		libXrender libSM libX11.i686 libXau.i686 libXdmcp.i686 libusb \
		libXext libXft-devel.i686 libXft.i686 libXrender.i686 \
		libXt.i686 libXtst.i686 libxml2.i686 ncurses-libs.i686 && \
	yum clean all && rm -rf /var/cache/yum

RUN grep -q ${gid} /etc/group || groupadd -g ${gid} altera
RUN useradd -u ${uid} -g ${gid} -m altera
        
ADD *.run /setup/
ADD *.qdz /setup/

# Modelsim is installed automatically if present
RUN	/setup/QuartusLiteSetup*.run \
		--mode unattended \
		--unattendedmodeui none \
		--installdir /opt/quartus_lite \
		--accept_eula 1 && \
	rm -rf /setup

# Fix Modelsim missing persmissions
RUN if [ -d /opt/quartus_lite/modelsim_ase ]; then find /opt/quartus_lite/modelsim_ase \! -perm /o+rwx -exec chmod o=g {} \;; fi

ENV PATH "$PATH:/opt/quartus_lite/quartus/bin"

CMD ["quartus", "--64bit"]
