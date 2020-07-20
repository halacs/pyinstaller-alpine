#ARG ALPINE_VERSION="3.6-alpine3.11" #NEM JO
ARG ALPINE_VERSION="3.8-alpine3.10"

FROM python:${ALPINE_VERSION}

ARG PYINSTALLER_TAG
ENV PYINSTALLER_TAG "develop"

# Official Python base image is needed or some applications will segfault.
# PyInstaller needs zlib-dev, gcc, libc-dev, and musl-dev
RUN apk --update --no-cache add \
    zlib-dev \
    musl-dev \
    libc-dev \
    libffi-dev \
    gcc \
    g++ \
    git \
    pwgen \
    libffi-dev \
    openssl-dev \
    libressl-dev

RUN pip install --upgrade pip

# Install pycrypto so --key can be used with PyInstaller
RUN pip install \
    pycrypto

# Build bootloader for alpine
RUN git clone --branch ${PYINSTALLER_TAG} https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller \
    && cd /tmp/pyinstaller/bootloader \
    && CFLAGS="-static-libgcc -static-libstdc++ -static -Wno-stringop-overflow -pie" python ./waf configure --no-lsb all --target-arch=64bit \
    && pip install .. \
    && rm -Rf /tmp/pyinstaller

VOLUME /src
WORKDIR /src

ADD ./bin /pyinstaller
RUN chmod a+x /pyinstaller/*

ENTRYPOINT ["/pyinstaller/pyinstaller.sh"]
