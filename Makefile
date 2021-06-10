
NAMES = pendb penmm penfe penadm

build:
	for n in $(NAMES) ; do (\
	    echo $${n} ; \
	    cd $${n} ; \
	    if [ "`docker images $${n}:build -q`" ] ; then \
		docker rmi $${n}:build ; \
	    fi ; \
	    docker build -t $${n}:build --build-arg __NC=`date +%Y%m%d%H%M%S` . \
	    ) ; done


