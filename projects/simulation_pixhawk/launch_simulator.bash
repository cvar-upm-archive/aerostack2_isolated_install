#!/bin/bash

#https://github.com/aerostack2-developers/PX4-Autopilot.git


PX4_FOLDER="$AEROSTACK2_WORKSPACE/src/thirdparty/PX4-Autopilot"

cd $PX4_FOLDER &&
    make px4_sitl_rtps gazebo
