#!/bin/bash

if [[ -z "$ROS_DISTRO" ]]; then
    echo ""; echo "[ERROR] ROS environment is not set. Exiting.."
    exit 1
fi

echo $(pwd)

sudo apt install tmux python3-pip python3-testresources -y && \
sudo apt install python3-colcon-common-extensions -y && \
sudo apt install ros-${ROS_DISTRO}-ament-cmake-clang-format -y &&\
sudo apt install ros-${ROS_DISTRO}-eigen3-cmake-module -y &&\
sudo apt install ros-${ROS_DISTRO}-gazebo-ros-pkgs -y &&\
sudo apt install ros-${ROS_DISTRO}-geographic-msgs -y &&\
sudo apt install libgeographic-dev geographiclib-tools &&\
sudo ln -s /usr/share/cmake/geographiclib/FindGeographicLib.cmake /usr/share/cmake-*/Modules/ &&\
sudo apt-get install -y libeigen3-dev -y &&\
sudo pip3 install -U empy pyros-genmsg setuptools &&\
sudo apt install libgoogle-glog* -y &&\
sudo apt install libgflags* -y &&\
sudo apt install libnlopt-cxx-dev -y &&\
sudo apt install libyaml-cpp* -y &&\
sudo usermod -a -G dialout $USER &&\
sudo apt-get remove modemmanager -y &&\
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y &&\
sudo udevadm control --reload-rules && udevadm trigger

source $HOME/.bashrc
