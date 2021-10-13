#!/bin/bash

echo $(pwd)

sudo apt install tmux python3-pip python3-testresources -y && \
sudo apt install python3-colcon-common-extensions -y && \
sudo apt install ros-${ROS_DISTRO}-ament-cmake-clang-format -y &&\
sudo apt install ros-${ROS_DISTRO}-eigen3-cmake-module -y &&\
sudo pip3 install -U empy pyros-genmsg setuptools &&\
sudo apt install libgoogle-glog-dev &&\
sudo usermod -a -G dialout $USER &&\
sudo apt-get remove modemmanager -y&&\
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y &&\
sudo udevadm control --reload-rules && udevadm trigger

