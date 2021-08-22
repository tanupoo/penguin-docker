FROM python:3.9.5-alpine3.12
RUN apk add git gcc musl-dev


ARG __NC=X
RUN mkdir /opt/penadm && \
    cd /opt/penadm && \
    git clone --recursive https://github.com/tanupoo/penguin bin
RUN cd /opt/penadm/bin && \
    pip install -r adm-reqs.txt

