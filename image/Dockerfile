FROM haskell:8.6.3

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