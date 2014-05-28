FROM mattdm/fedora
MAINTAINER Gideon Sireling <gideon@accursoft.com>

ADD ghc.sh /tmp/
RUN /tmp/ghc.sh
RUN rm /tmp/ghc.sh
