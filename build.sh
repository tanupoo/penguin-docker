#!/bin/sh

ALL="pendb penmm penfe penen penadm"

name=$1
if [ ! "$name" ] ; then
    echo "Usage: build.sh (name)"
    echo "    name: ${ALL}"
    exit -1
fi

build_image()
{
    name=$1
    echo "==== Build ${name} ===="
    cd ${name} && \
    if [ "`docker images ${name}:build -q`" ] ; then
        docker rmi ${name}:build ;
    fi
    docker build -t ${name}:build --build-arg __NC=`date +%Y%m%d%H%M%S` .
}

push_image()
{
    tag=`grep ${name} latest-versions.txt | cut -d: -f2`
    pubname=tanupoo/${name}:${tag}
    echo "==== Push ${pubname} ===="
    docker tag ${name}:build ${pubname} && \
    docker push ${pubname}
}

push_image ${name}
