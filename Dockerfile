FROM ubuntu:xenial

LABEL maintainer "https://github.com/blacktop"

LABEL malice.plugin.repository = "https://github.com/malice-plugins/escan.git"
LABEL malice.plugin.category="av"
LABEL malice.plugin.mime="*"
LABEL malice.plugin.docker.engine="*"

ENV ESCAN 7.0-20

RUN buildDeps='ca-certificates wget gdebi sudo' \
  && set -x \
  && apt-get update -qq \
  && apt-get install -yq $buildDeps libc6-i386 \
  && echo "===> Install eScan AV..." \
  && wget -q -P /tmp http://www.microworldsystems.com/download/linux/soho/deb/escan-antivirus-wks-${ESCAN}.amd64.deb \
  && DEBIAN_FRONTEND=noninteractive gdebi -n /tmp/escan-antivirus-wks-${ESCAN}.amd64.deb \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV GO_VERSION 1.8.3

COPY . /go/src/github.com/malice-plugins/escan
RUN buildDeps='ca-certificates \
               build-essential \
               gdebi-core \
               libssl-dev \
               mercurial \
               git-core \
               wget' \
  && apt-get update -qq \
  && apt-get install -yq $buildDeps libc6-i386 \
  && set -x \
  && echo "===> Install Go..." \
  && ARCH="$(dpkg --print-architecture)" \
  && wget -q https://storage.googleapis.com/golang/go$GO_VERSION.linux-$ARCH.tar.gz -O /tmp/go.tar.gz \
  && tar -C /usr/local -xzf /tmp/go.tar.gz \
  && export PATH=$PATH:/usr/local/go/bin \
  && echo "===> Building avscan Go binary..." \
  && cd /go/src/github.com/malice-plugins/escan \
  && export GOPATH=/go \
  && go version \
  && go get \
  && go build -ldflags "-X main.Version=$(cat VERSION) -X main.BuildTime=$(date -u +%Y%m%d)" -o /bin/avscan \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /go /usr/local/go

# Update eScan
RUN escan --update

# Add EICAR Test Virus File to malware folder
ADD http://www.eicar.org/download/eicar.com.txt /malware/EICAR

WORKDIR /malware

ENTRYPOINT ["/bin/avscan"]
CMD ["--help"]
