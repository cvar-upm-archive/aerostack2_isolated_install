#!/bin/bash

echo $(pwd)


sudo apt install tmux -y && \
sudo apt install python3-colcon-common-extensions -y && \
sudo apt install ros-foxy-ament-cmake-clang-format -y && \ 


# Todo: add this to a package installer
#---------------------------------------

cd ..
mkdir thirdparty/
cd thirdparty

git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git -b v1.0.4 \
    && cd Fast-DDS-Gen \
    && ./gradlew assemble \
    && sudo ./gradlew install

# Check FastRTPSGen version
fastrtpsgen_version_out=""
if [[ -z $FASTRTPSGEN_DIR ]]; then
  fastrtpsgen_version_out="$FASTRTPSGEN_DIR/$(fastrtpsgen -version)"
else
  fastrtpsgen_version_out=$(fastrtpsgen -version)
fi
if [[ -z $fastrtpsgen_version_out ]]; then
  echo "FastRTPSGen not found! Please build and install FastRTPSGen..."
  exit 1
else
  fastrtpsgen_version="${fastrtpsgen_version_out: -5:-2}"
  if ! [[ $fastrtpsgen_version =~ ^[0-9]+([.][0-9]+)?$ ]] ; then
    fastrtpsgen_version="1.0"
    [ ! -v $verbose ] && echo "FastRTPSGen version: ${fastrtpsgen_version}"
  else
    [ ! -v $verbose ] && echo "FastRTPSGen version: ${fastrtpsgen_version_out: -5}"
  fi
fi


# Todo: add this to a package installer
#---------------------------------------

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE &&\
sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u &&\
sudo apt update ;\
sudo apt install librealsense2-dkms -y && \
sudo apt install librealsense2-utils -y && \
sudo apt install librealsense2-dev -y && \
sudo apt install librealsense2-dbg -y && \
sudo wget https://raw.githubusercontent.com/IntelRealSense/librealsense/master/config/99-realsense-libusb.rules --directory /etc/udev/rules.d/ 
#----------------------------------------
