FROM accursoft/micro-jessie

COPY ghc.sh build.mk /tmp/
RUN /tmp/ghc.sh

#switch on gold linker
#we can't do this earlier because the apt-installed ghc can't use it
#https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=718814#15
RUN update-alternatives --install /usr/bin/ld ld /usr/bin/ld.gold 20

COPY cabal.sh /tmp/
RUN /tmp/cabal.sh

COPY framework.sh /tmp/
ARG framework=network
RUN /tmp/framework.sh $framework
CMD ["cat", "/opt/s2i/provides"]

RUN rm -rf /tmp/*

RUN useradd -r -m -k /dev/null -s /usr/sbin/nologin build
USER build

#generate default cabal config
RUN cabal get && sed -i 's/-- library-for-ghci:/library-for-ghci: False/' /home/build/.cabal/config

#environment for builds and expose server port
ENV PORT=8080 \
    PATH=$PATH:/home/build/.cabal/bin
EXPOSE $PORT

#s2i scripts
COPY s2i /opt/s2i/