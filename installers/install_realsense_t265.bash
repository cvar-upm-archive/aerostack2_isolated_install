#!/bin/bash


# if [$(dpkg-architecture -q DEB_BUILD_ARCH) == "arm64"]; then
#   sudo apt install ros-${ROS_DISTRO}-realsense2-camera*
# else
#     echo "USING x86 ARCHITECTURE" 
#     exit 1 
#     sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE &&\
#     sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u &&\
#     sudo apt update ;\
#     sudo apt install librealsense2-dkms -y && \
#     sudo apt install librealsense2-utils -y && \
#     sudo apt install librealsense2-dev -y && \
#     sudo apt install librealsense2-dbg -y && \
# fi

sudo apt install ros-${ROS_DISTRO}-realsense2-camera* &&
sudo wget https://raw.githubusercontent.com/IntelRealSense/librealsense/master/config/99-realsense-libusb.rules --directory /etc/udev/rules.d/ 




