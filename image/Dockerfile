FROM accursoft/micro-debian

COPY ghc.sh build.mk /tmp/
RUN /tmp/ghc.sh

COPY cabal.sh /tmp/
RUN /tmp/cabal.sh

COPY framework.sh /tmp/
ARG framework=network
RUN /tmp/framework.sh $framework
CMD ["cat", "/opt/s2i/provides"]

RUN rm -rf /tmp/*

RUN adduser --system --shell /usr/sbin/nologin -u 101 build
USER 101

#generate default cabal config
RUN cabal get && sed -i 's/-- library-for-ghci:/library-for-ghci: False/' /home/build/.cabal/config

#environment for builds and expose server port
ENV PORT=8080 \
    PATH=$PATH:/home/build/.cabal/bin
EXPOSE $PORT

#s2i scripts
COPY s2i /opt/s2i/