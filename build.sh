#!/bin/sh

ALL="pendb penmm penfe penen penadm"

usage()
{
    echo "Usage: build.sh [-p] (name)"
    echo "    name: ${ALL}"
    exit -1
}

build_image()
{
    (
        name=$1
        echo "==== Build ${name} ===="
        if [ ! -d "${name}" ] ; then
            echo "ERROR: $name doesn't exist."
            return
        fi
        cd ${name} && \
        if [ "`docker images ${name}:build -q`" ] ; then
            docker rmi ${name}:build ;
        fi && \
        docker build -t ${name}:build --build-arg __NC=`date +%Y%m%d%H%M%S` .
    )
}

push_image()
{
    (
        name=$1
        tag=`grep ${name} latest-versions.txt | cut -d: -f2`
        pubname=tanupoo/${name}:${tag}
        echo "==== Push ${pubname} ===="
        docker tag ${name}:build ${pubname} && \
        docker push ${pubname}
    )
}

#
# main
#
if [ "$1" = "-p" ] ; then
    mode="push_image"
    shift
    targets=$*
else
    mode="build_image"
    targets=$*
fi

if [ -z "$targets" ] ; then
    usage
fi

for t in ${targets}
do
    $mode $t
done

