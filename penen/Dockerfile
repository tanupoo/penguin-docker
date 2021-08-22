FROM python:3.9.5-alpine3.12
RUN apk add git gcc musl-dev
RUN apk add linux-headers

ARG __NC=X
RUN mkdir /opt/penen && \
    cd /opt/penen && \
    git clone --recursive https://github.com/tanupoo/penguin bin
RUN cd /opt/penen/bin && \
    pip install -r en-reqs.txt

