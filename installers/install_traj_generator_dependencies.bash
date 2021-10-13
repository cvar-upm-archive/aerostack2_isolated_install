#!/bin/bash

cd $AEROSTACK_WORKSPACE/src/thirdparty

git clone https://github.com/google/glog.git &&\
    cd glog &&\
    cmake -S . -B build -G "Unix Makefiles" &&\
    cmake --build build &&\
    sudo cmake --build build --target install

##TODO: check if nlopt must be installed locally too
