FROM python:3.9.5-alpine3.12
RUN apk add git gcc musl-dev

RUN mkdir /opt/pendb && \
    cd /opt/pendb && \
    git clone --recursive https://github.com/tanupoo/proto-patient-entry bin
RUN cd /opt/pendb/bin && \
    pip install -r db-reqs.txt

