#!/bin/bash

BASEDIR=$PWD

echo "-------------------------------------------------------"
echo "Installing dependencies"
echo "-------------------------------------------------------"

if ! command -v vcs &> /dev/null; then
    echo "vcs could not be found"
	echo "installing vcs_tool..."
	sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
	sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xAB17C654
	sudo apt update
	sudo apt install python3-vcstool
else 
	echo "vcs installed"
fi

#TODO: handle error in dependencies

#bash $BASEDIR/install_core_dependencies.bash
echo "todo bien"
if [ $? -eq 0 ]; then
   echo OK
else
   echo "" ;echo "ERROR:" 
   echo "Dependencies were not installed properly" 
   exit 1
fi


echo "-------------------------------------------------------"
echo "Downloading packages"
echo "-------------------------------------------------------"

cd ..
echo "VCS IMPORTING __ THIS IS FOR TEST"
vcs import --recursive < "./installers/core_repositories.repos"

echo "-------------------------------------------------------"
echo "Setting environment variables"
echo "-------------------------------------------------------"

# TODO: use folder as a parameter
AEROSTACK2_WORKSPACE="$(dirname $(dirname "$(pwd)"))"
AEROSTACK2_STACK="$(pwd)"
AEROSTACK2_PROJECTS="$AEROSTACK2_STACK/projects/"

echo ${AEROSTACK2_WORKSPACE}
echo ${AEROSTACK2_STACK}

# grep -q "source $AEROSTACK2_WORKSPACE/install/setup.bash" $HOME/.bashrc || echo "source $AEROSTACK2_WORKSPACE/install/setup.bash" >> $HOME/.bashrc
sed -i '/export AEROSTACK2_STACK/d' $HOME/.bashrc && echo "export AEROSTACK2_STACK=${AEROSTACK2_STACK}" >> $HOME/.bashrc
sed -i '/source $AEROSTACK2_STACK/d' $HOME/.bashrc && echo 'source $AEROSTACK2_STACK/scripts/setup_env.bash' >> $HOME/.bashrc

cd $AEROSTACK2_WORKSPACE
echo "colcon build"
colcon build --symlink-install
