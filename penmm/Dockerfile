FROM python:3.9.5-alpine3.12
RUN apk add git gcc musl-dev
RUN apk add zlib-dev jpeg-dev

ARG __NC=X
RUN mkdir /opt/penmm && \
    cd /opt/penmm && \
    git clone --recursive https://github.com/tanupoo/penguin bin
RUN cd /opt/penmm/bin && \
    pip install -r mm-reqs.txt

