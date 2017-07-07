FROM ubuntu:precise

LABEL maintainer "https://github.com/blacktop"

LABEL malice.plugin.repository = "https://github.com/malice-plugins/escan.git"
LABEL malice.plugin.category="av"
LABEL malice.plugin.mime="*"
LABEL malice.plugin.docker.engine="*"

ENV ESVERSION 7.0-20

RUN apt-get update && apt-get install -yq libc6-i386 gdebi wget

WORKDIR /tmp

ADD http://www.microworldsystems.com/download/linux/soho/deb/escan-antivirus-wks-${ESVERSION}.amd64.deb /tmp

# Install eScan
RUN DEBIAN_FRONTEND=noninteractive gdebi -n /tmp/escan-antivirus-wks-${ESVERSION}.amd64.deb

# Update eScan
RUN escan --update

# Add EICAR Test Virus File to malware folder
ADD http://www.eicar.org/download/eicar.com.txt /malware/EICAR

ENTRYPOINT bash
