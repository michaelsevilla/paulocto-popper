FROM ubuntu:trusty

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install -y mpich cmake libfuse-dev libfuse2 zlib1g-dev man-db && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* debian/

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
