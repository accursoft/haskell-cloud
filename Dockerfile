FROM fedora
MAINTAINER Gideon Sireling <gideon@accursoft.com>

ADD ghc.sh /tmp/
RUN /tmp/ghc.sh

ADD cabal.sh /tmp/
RUN /tmp/cabal.sh

RUN rm -rf /tmp/*
