#!/bin/bash

# Install dependencies

PX4_FOLDER="$AEROSTACK2_WORKSPACE/src/thirdparty/PX4-Autopilot"

cd $AEROSTACK2_WORKSPACE/src/thirdparty/
git clone --recurse-submodules -j$(nproc) https://github.com/aerostack2-developers/PX4-Autopilot.git && \
    cp $AEROSTACK2_STACK/thirdparty/px4_required_packages/px4_configs/urtps_bridge_topics.yaml $PX4_FOLDER/msg/tools/ && \
    bash $PX4_FOLDER/Tools/setup/ubuntu.sh

