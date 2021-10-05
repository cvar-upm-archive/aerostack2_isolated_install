#!/bin/bash

# Todo: add this to a package installer
#---------------------------------------

# install not ros dependencies

cd ../../
mkdir thirdparty/
cd thirdparty
touch COLCON_IGNORE

sudo apt install openjdk-11-jdk

git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git -b v1.0.4 \
    && cd Fast-DDS-Gen \
    && ./gradlew assemble \
    && sudo ./gradlew install

source ~/.bashrc

cd ../

git clone https://github.com/eProsima/foonathan_memory_vendor.git \
    && cd foonathan_memory_vendor \
    && mkdir build && cd build \
    && cmake .. \
    && sudo cmake --build . --target install 

cd ../
cd ../

# CHECK IF THIS IS NECESSARY
git clone --recursive https://github.com/eProsima/Fast-DDS.git -b v2.0.0 ~/FastDDS-2.0.0 \
&& cd ~/FastDDS-2.0.0\
&& mkdir build && cd build\
&& cmake -DTHIRDPARTY=ON -DSECURITY=ON .. \
&& make -j$(nproc --all) \
&& sudo make install 

source ~/.bashrc

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


if [$(dpkg-architecture -q DEB_BUILD_ARCH) == "arm64"]; then
    sudo apt install ros-${ROS_DISTRO}-realsense2-camera*
else
    echo "USING x86 ARCHITECTURE" 
    exit 1 
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE &&\
    sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u &&\
    sudo apt update ;\
    sudo apt install librealsense2-dkms -y && \
    sudo apt install librealsense2-utils -y && \
    sudo apt install librealsense2-dev -y && \
    sudo apt install librealsense2-dbg -y && \
fi

sudo wget https://raw.githubusercontent.com/IntelRealSense/librealsense/master/config/99-realsense-libusb.rules --directory /etc/udev/rules.d/ 
#----------------------------------------


