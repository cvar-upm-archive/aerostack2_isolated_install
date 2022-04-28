#!/bin/bash
echo "AS2 is setting up the environment..."

if [ "$ZSH_VERSION" = "" ]; then
    echo "using bash as your shell..."
    TERM_EXTENSION=".bash"
else
    echo "using zsh"
    TERM_EXTENSION=".zsh"
fi

# check if AEROSTACK2_STACK is set
if [ -z "$AEROSTACK2_STACK" ]; then
  echo "AEROSTACK2_STACK is not set. Please set it to the path of the AEROSTACK2_STACK folder"
  exit 1
fi

export AEROSTACK2_WORKSPACE=$(dirname $(dirname ${AEROSTACK2_STACK}))
export AEROSTACK2_PROJECTS="$AEROSTACK2_STACK/projects/"
export PATH=$PATH:$AEROSTACK2_STACK/scripts/

ENV_VARIABLES_FILE="$AEROSTACK2_STACK/scripts/env_variables.bash"
if test -f "$ENV_VARIABLES_FILE"; then
    source $ENV_VARIABLES_FILE
else
    echo "export AEROSTACK2_SIMULATION_DRONE_ID=drone_sim_${USER}_0" >> $ENV_VARIABLES_FILE
    source $ENV_VARIABLES_FILE
fi

# enable custom AS2 bash completions
source $AEROSTACK2_STACK/scripts/_as2

alias as2_set_ros2_env="\
source /opt/ros/foxy/setup${TERM_EXTENSION} && \
source $AEROSTACK2_WORKSPACE/install/setup${TERM_EXTENSION}"

if [ -d "$AEROSTACK2_STACK/ros1_stack/ros1_packages/devel/" ];
then
  alias as2_set_ros1_env="\
  source /opt/ros/noetic/setup${TERM_EXTENSION} &&\
  source $AEROSTACK2_STACK/ros1_stack/ros1_packages/devel/setup${TERM_EXTENSION}"
fi

if [ -d "$AEROSTACK2_STACK/ros1_stack/ros1_bridge/install/" ]; then
  alias as2_run_ros1_bridge="\
  source $AEROSTACK2_STACK/ros1_stack/ros1_bridge/install/setup${TERM_EXTENSION} && \
  source ${AEROSTACK2_WORKSPACE}/install/setup${TERM_EXTENSION} && \
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

