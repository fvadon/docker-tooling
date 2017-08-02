FROM nuxeo:9.2

USER root

RUN echo "deb http://httpredir.debian.org/debian stretch non-free" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y --no-install-recommends libfaac-dev git libx264-dev

WORKDIR /tmp
# Build ffmpeg
ENV BUILD_YASM true
ENV LIBFAAC true
RUN git clone https://github.com/nuxeo/ffmpeg-nuxeo.git
WORKDIR ffmpeg-nuxeo
RUN sed -ie "s/\.\/configure/\.\/configure --enable-shared --enable-pic/" build-libvpx.sh \
 && sed -ie "s/\.\/configure.*$/\.\/configure --enable-static --enable-shared --enable-pic/" build-x264.sh \
 && ./prepare-packages.sh \
 && ./build-yasm.sh \
 && ./build-x264.sh \
 && ./build-libvpx.sh \
 && ./build-ffmpeg.sh \
 && cd /tmp \
 && rm -Rf ffmpeg-nuxeo \
 && rm -rf /var/lib/apt/lists/*

USER 1000
