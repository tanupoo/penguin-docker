FROM python:3.9.5-alpine3.12
RUN apk add git gcc zlib-dev jpeg-dev musl-dev

RUN mkdir /opt/penmm && \
    cd /opt/penmm && \
    git clone --recursive https://github.com/tanupoo/proto-patient-entry bin
RUN cd /opt/penmm/bin && \
    pip install -r mm-reqs.txt

