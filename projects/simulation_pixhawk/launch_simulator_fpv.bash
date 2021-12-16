#!/bin/bash
[ -d "/usr/share/gazebo-7" ] && export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-7
[ -d "/usr/share/gazebo-9" ] && export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-9
[ -d "/usr/share/gazebo-11" ] && export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11

echo "Killing gazebo"
pkill -9 gzserver
pkill -9 gzclient
sleep 1

AEROSTACK_PROJECT=$(pwd)

#SIMULATE WITHOUT CAMERA
	#(cd $(rospack find px4) ; make px4_sitl gazebo)

#SIMULATE WITH CAMERA


WORLD_FILE="${AEROSTACK_PROJECT}/configs/gazebo/worlds/frames_manual.world"
UAV_NAME="iris"
MODEL_FOLDER="${AEROSTACK_PROJECT}/configs/gazebo/models"

sed -i -r "s/(<namespace>).+[[:alnum:]].+(<\/namespace>)/\1$AEROSTACK2_SIMULATION_DRONE_ID\2/" "$MODEL_FOLDER/$UAV_NAME/iris.sdf"

cp "$MODEL_FOLDER/$UAV_NAME/iris.sdf" "$MODEL_FOLDER/$UAV_NAME/iris.sdf.jinja"
cp "$MODEL_FOLDER/$UAV_NAME/iris.sdf" "$MODEL_FOLDER/$UAV_NAME/iris.sdf.last_generated"

PX4_FOLDER="$AEROSTACK2_WORKSPACE/src/thirdparty/PX4-Autopilot"

(cd $PX4_FOLDER; DONT_RUN=1 make px4_sitl_rtps gazebo)
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$PX4_FOLDER:$PX4_FOLDER/Tools/sitl_gazebo
export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$MODEL_FOLDER
export PX4_SITL_WORLD=$WORLD_FILE
export GAZEBO_PLUGIN_PATH=$PX4_FOLDER/build/px4_sitl_rtps/build_gazebo
# export GAZEBO_MODEL_PATH=${AEROSTACK_PROJECT}/configs/gazebo/models
# source $PX4_FOLDER/Tools/setup_gazebo.bash $PX4_FOLDER $PX4_FOLDER/build/px4_sitl_rtps
source $PX4_FOLDER/build/px4_sitl_rtps/build_gazebo/setup.sh

# bash launch_simulator.bash
$PX4_FOLDER/Tools/sitl_run.sh "$PX4_FOLDER/build/px4_sitl_rtps/bin/px4" none gazebo none $WORLD_FILE $PX4_FOLDER $PX4_FOLDER/build/px4_sitl_rtps

# echo "Killing gazebo"
# pkill -9 gzserver
# pkill -9 gzclient
