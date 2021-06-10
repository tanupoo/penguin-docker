FROM python:3.9.5-alpine3.12
RUN apk add git gcc musl-dev

RUN mkdir /opt/penadm && \
    cd /opt/penadm && \
    git clone --recursive https://github.com/tanupoo/proto-patient-entry bin
RUN cd /opt/penadm/bin && \
    pip install -r adm-reqs.txt

