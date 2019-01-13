ARG version
FROM haskell:$version

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

# https://github.com/moby/moby/issues/34129
ARG version
LABEL io.openshift.s2i.scripts-url="image://opt/s2i" \
      io.k8s.display-name="Haskell" \
      io.k8s.description="GHC and build tools" \
      io.openshift.tags="haskell,ghc,ghc-$version,builder" \
      io.openshift.expose-services="8080:http"
