FROM nuxeo:latest

RUN echo "deb http://httpredir.debian.org/debian jessie non-free" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends libfaac-dev git

WORKDIR /tmp
# Build ffmpeg
ENV BUILD_YASM true
ENV LIBFAAC true
RUN git clone https://github.com/nuxeo/ffmpeg-nuxeo.git
WORKDIR ffmpeg-nuxeo
RUN ./prepare-packages.sh \
 && ./build-yasm.sh \
 && ./build-x264.sh \
 && ./build-libvpx.sh \
 && ./build-ffmpeg.sh \
 && cd /tmp \
 && rm -Rf ffmpeg-nuxeo \
 && rm -rf /var/lib/apt/lists/*
