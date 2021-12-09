#!/bin/bash
echo "AS2 is setting up the environment..."

# check if AEROSTACK2_STACK is set
if [ -z "$AEROSTACK2_STACK" ]; then
  echo "AEROSTACK2_STACK is not set. Please set it to the path of the AEROSTACK2_STACK folder"
  exit 1
fi

export AEROSTACK2_SIMULATION_DRONE_ID=drone_sim_11 

export AEROSTACK2_WORKSPACE=$(dirname $(dirname ${AEROSTACK2_STACK}))
export AEROSTACK2_PROJECTS="$AEROSTACK2_STACK/projects/"
export PATH=$PATH:$AEROSTACK2_STACK/scripts/

alias as2_set_ros2_env="\
source /opt/ros/foxy/setup.bash && \
source $AEROSTACK2_WORKSPACE/install/setup.bash"

if [ -d "$AEROSTACK2_STACK/ros1_stack/ros1_packages/devel/" ];
then
  alias as2_set_ros1_env="\
  source /opt/ros/noetic/setup.bash &&\
  source $AEROSTACK2_STACK/ros1_stack/ros1_packages/devel/setup.bash"
fi

if [ -d "$AEROSTACK2_STACK/ros1_stack/ros1_bridge/install/" ]; then
  alias as2_run_ros1_bridge="\
  source $AEROSTACK2_STACK/ros1_stack/ros1_bridge/install/setup.bash && \
  source ${AEROSTACK2_WORKSPACE}/install/setup.bash && \
  export ROS_MASTER_URI=http://localhost:11311 &&\
  ros2 run ros1_bridge dynamic_bridge"  
fi

parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
parse_ros_version() {
  if (rosversion -d | sed -e 's/^.*://' -e 's/ .*//') | grep -q 'foxy'; then
    echo '[ROS2]'
  elif (rosversion -d | sed -e 's/^.*://' -e 's/ .*//') | grep -q 'noetic'; then
    echo '[ROS1]'
  else
    echo ''
  fi
}

force_color_prompt=yes
color_prompt=yes
if [ "$color_prompt" = yes ]; then
 PS1='\[\033[32m\]$(parse_ros_version)\[\033[00m\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
else
 PS1='$(parse_ros_version)${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi



