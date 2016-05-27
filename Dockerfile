FROM ubuntu:16.04
MAINTAINER Michael Bekaert <michael.bekaert@stir.ac.uk>

ENV DOCKERVERSION 1.0

USER root

RUN apt-get update
RUN echo "echo \"Hello world: ${DOCKERVERSION}\"" > /root/test.sh && chmod 555 /root/test.sh

WORKDIR /root
