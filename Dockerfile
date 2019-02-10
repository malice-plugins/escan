####################################################
# GOLANG BUILDER
####################################################
FROM golang:1.11 as go_builder

COPY . /go/src/github.com/malice-plugins/escan
WORKDIR /go/src/github.com/malice-plugins/escan
RUN go get -u github.com/golang/dep/cmd/dep && dep ensure
RUN go build -ldflags "-s -w -X main.Version=v$(cat VERSION) -X main.BuildTime=$(date -u +%Y%m%d)" -o /bin/avscan

####################################################
# PLUGIN BUILDER
####################################################
FROM ubuntu:xenial

LABEL maintainer "https://github.com/blacktop"

LABEL malice.plugin.repository = "https://github.com/malice-plugins/escan.git"
LABEL malice.plugin.category="av"
LABEL malice.plugin.mime="*"
LABEL malice.plugin.docker.engine="*"

# Create a malice user and group first so the IDs get set the same way, even as
# the rest of this may change over time.
RUN groupadd -r malice \
  && useradd --no-log-init -r -g malice malice \
  && mkdir /malware \
  && chown -R malice:malice /malware

ENV ESCAN 7.0-20

RUN buildDeps='wget ca-certificates gdebi' \
  && set -x \
  && dpkg --add-architecture i386 \
  && apt-get update -qq \
  && apt-get install -yq $buildDeps libc6-i386 --no-install-recommends \
  && echo "===> Install eScan AV..." \
  && wget -q -P /tmp http://www.microworldsystems.com/download/linux/soho/deb/escan-antivirus-wks-${ESCAN}.amd64.deb \
  && DEBIAN_FRONTEND=noninteractive gdebi -n /tmp/escan-antivirus-wks-${ESCAN}.amd64.deb \
  && echo "===> Clean up unnecessary files..." \
  && apt-get remove -y $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.gnupg

# Ensure ca-certificates is installed for elasticsearch to use https
RUN apt-get update -qq && apt-get install -yq --no-install-recommends ca-certificates wget \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update eScan
RUN mkdir -p /opt/malice && escan --update

# Add EICAR Test Virus File to malware folder
ADD http://www.eicar.org/download/eicar.com.txt /malware/EICAR

COPY --from=go_builder /bin/avscan /bin/avscan

WORKDIR /malware

ENTRYPOINT ["/bin/avscan"]
CMD ["--help"]

####################################################
####################################################