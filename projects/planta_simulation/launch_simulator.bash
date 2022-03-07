#!/bin/bash

# Parsing cli
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -h | --help )
    echo usage: launch_simulator.bash [-h] [--fpv]
    exit 1
    ;;
  --fpv )
    fpv=1
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi


[ -d "/usr/share/gazebo-7" ] && export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-7
[ -d "/usr/share/gazebo-9" ] && export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-9
[ -d "/usr/share/gazebo-11" ] && export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11

echo "Killing gazebo"
pkill -9 gzserver
pkill -9 gzclient
sleep 1

AEROSTACK_PROJECT=$(pwd)

PX4_FOLDER="$AEROSTACK2_WORKSPACE/src/thirdparty/PX4-Autopilot"

WORLD_FILE="${AEROSTACK_PROJECT}/configs/gazebo/worlds/planta.world"

export VEHICLE="iris"
if [[ "$fpv" == "1" ]]; then
	UAV_MODEL="iris_fpv"
else
	UAV_MODEL="iris"
fi
MODEL_FOLDER="${AEROSTACK_PROJECT}/configs/gazebo/models"

if [[ -e FILE ]]; then
	sed -i -r "s/(<namespace>).+[[:alnum:]].+(<\/namespace>)/\1$AEROSTACK2_SIMULATION_DRONE_ID\2/" "$MODEL_FOLDER/$UAV_MODEL/$UAV_MODEL.sdf"
fi

export PX4_NO_FOLLOW_MODE=1

export PX4_HOME_LAT=28.143993735855286
export PX4_HOME_LON=-16.50324122923412
export PX4_HOME_ALT=0

(cd $PX4_FOLDER; DONT_RUN=1 make px4_sitl_rtps gazebo)
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$PX4_FOLDER:$PX4_FOLDER/Tools/sitl_gazebo
export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$MODEL_FOLDER
export PX4_SITL_WORLD=$WORLD_FILE
export GAZEBO_PLUGIN_PATH=$PX4_FOLDER/build/px4_sitl_rtps/build_gazebo
source $PX4_FOLDER/build/px4_sitl_rtps/build_gazebo/setup.sh

export UAV_X=-5.0
export UAV_Y=0.0
export UAV_Z=0.0
export UAV_YAW=1.57
$AEROSTACK_PROJECT/sitl_run.sh "$PX4_FOLDER/build/px4_sitl_rtps/bin/px4" none gazebo $UAV_MODEL $WORLD_FILE $PX4_FOLDER $PX4_FOLDER/build/px4_sitl_rtps
