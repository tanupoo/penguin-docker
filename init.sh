#!/bin/sh

if [ ! -d "ui" ] ; then
    echo "==> cloning penguin-ui"
    git clone https://github.com/tanupoo/penguin-ui ui
fi

if [ ! -f "penen/ui/index.html" ] ; then
    echo "==> creating link for penen/ui"
    ln -s ../ui/step1/dist penen/ui
fi

if [ ! -f "penfe/ui/index.html" ] ; then
    echo "==> creating link for penfe/ui"
    ln -s ../ui/step2/dist penfe/ui
fi
