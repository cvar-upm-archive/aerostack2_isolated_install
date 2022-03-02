#!/bin/bash

#https://github.com/aerostack2-developers/PX4-Autopilot.git


PX4_FOLDER="${AEROSTACK2_WORKSPACE}src/thirdparty/PX4-Autopilot"

# WORLD_FILE="${AEROSTACK_PROJECT}/configs/gazebo/worlds/empty.world"
WORLD_FILE="${AEROSTACK2_PROJECTS}planta_simulation/configs/gazebo/worlds/planta.world"

UAV_NAME="iris"
MODEL_FOLDER="${AEROSTACK2_PROJECTS}planta_simulation/configs/gazebo/models"

sed -i -r "s/(<namespace>).+[[:alnum:]].+(<\/namespace>)/\1$AEROSTACK2_SIMULATION_DRONE_ID\2/" "$MODEL_FOLDER/$UAV_NAME/iris.sdf"

cp "$MODEL_FOLDER/$UAV_NAME/iris.sdf" "$MODEL_FOLDER/$UAV_NAME/iris.sdf.jinja"
cp "$MODEL_FOLDER/$UAV_NAME/iris.sdf" "$MODEL_FOLDER/$UAV_NAME/iris.sdf.last_generated"

# cd $PX4_FOLDER &&
#     make px4_sitl_rtps gazebo

# export PX4_NO_FOLLOW_MODE=1

export PX4_HOME_LAT=28.143993735855286
export PX4_HOME_LON=-16.50324122923412
export PX4_HOME_ALT=0

export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$PX4_FOLDER:$PX4_FOLDER/Tools/sitl_gazebo
export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$MODEL_FOLDER
export PX4_SITL_WORLD=$WORLD_FILE
export GAZEBO_PLUGIN_PATH=$PX4_FOLDER/build/px4_sitl_rtps/build_gazebo
# source $PX4_FOLDER/build/px4_sitl_rtps/build_gazebo/setup.sh


$PX4_FOLDER/Tools/sitl_run.sh "$PX4_FOLDER/build/px4_sitl_rtps/bin/px4" none gazebo none $WORLD_FILE $PX4_FOLDER $PX4_FOLDER/build/px4_sitl_rtps
