#!/bin/bash

if [[ -z "$ROS_DISTRO" ]]; then
    echo ""; echo "[ERROR] ROS environment is not set. (ROS_DISTRO env variable empty) Exiting.."
    exit 1
fi

sudo apt update
# utils
sudo apt install tmux python3-vcstool -y

# libs
sudo apt install libyaml-cpp* -y &&\
sudo apt install libeigen3-dev -y

# python dependencies
sudo apt install python3-pip python3-testresources -y && \
sudo apt install python3-colcon-common-extensions -y

# ros2 dependencies

sudo apt install ros-${ROS_DISTRO}-ament-cmake-clang-format -y &&\
sudo apt install ros-${ROS_DISTRO}-eigen3-cmake-module -y 

# sudo apt install ros-${ROS_DISTRO}-gazebo-ros-pkgs -y &&\
# sudo apt install ros-${ROS_DISTRO}-geographic-msgs -y

# geographic lib
# sudo apt install libgeographic-dev geographiclib-tools -y &&\
# sudo ln -s /usr/share/cmake/geographiclib/FindGeographicLib.cmake /usr/share/cmake-*/Modules/ &&\
# sudo pip3 install -U empy pyros-genmsg setuptools jinja2

# libgoogle utils

# sudo apt install libgoogle-glog* -y &&\
# sudo apt install libgflags* -y &&\
# sudo apt install libnlopt-cxx-dev -y

# USB Drivers
# sudo usermod -a -G dialout $USER &&\
# sudo apt-get remove modemmanager -y &&\
# sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y &&\
# sudo udevadm control --reload-rules && udevadm trigger
