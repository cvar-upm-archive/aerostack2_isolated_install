#!/bin/bash

if [ -z "$1" ]
then
    if [ -z "$AEROSTACK2_REAL_DRONE_ID" ] 
        then
        echo "no drone id was given, using default real drone_id = \"drone0\" "
        DRONE_ID_NAMESPACE="drone0"
    else
        DRONE_ID_NAMESPACE=$AEROSTACK2_REAL_DRONE_ID
    fi
else
DRONE_ID_NAMESPACE=$1
fi

echo "using \"/$DRONE_ID_NAMESPACE/\" namespace"

SESSION=$USER

UAV_MASS=1.5
UAV_MAX_THRUST=23.0

# Kill any previous session (-t -> target session, -a -> all other sessions )
tmux kill-session -t $SESSION
tmux kill-session -a

# Create new session  (-2 allows 256 colors in the terminal, -s -> session name, -d -> not attach to the new session)
tmux -2 new-session -d -s $SESSION

# Create roscore 
# send-keys writes the string into the sesssion (-t -> target session , C-m -> press Enter Button)
tmux rename-window -t $SESSION:0 'RTPS interface'
tmux send-keys -t $SESSION:0 "micrortps_agent  -d /dev/ttyUSB0 -n $DRONE_ID_NAMESPACE" C-m

tmux new-window -t $SESSION:1 -n 'pixhawk interface'
tmux send-keys "ros2 launch pixhawk_platform pixhawk_platform_launch.py \
    drone_id:=$DRONE_ID_NAMESPACE \
    mass:=$UAV_MASS \
    max_thrust:=$UAV_MAX_THRUST \
    simulation_mode:=false" C-m

tmux new-window -t $SESSION:2 -n 'df_controller'
tmux send-keys "ros2 launch differential_flatness_based_controller differential_flattness_controller_launch.py \
    drone_id:=$DRONE_ID_NAMESPACE " C-m

tmux new-window -t $SESSION:3 -n 'traj_generator'
tmux send-keys "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    drone_id:=$DRONE_ID_NAMESPACE " C-m

tmux new-window -t $SESSION:4 -n 'follow_path_behaviour'
tmux send-keys "ros2 launch as2_basic_behaviours follow_path_behaviours_launch.py \
    drone_id:=$DRONE_ID_NAMESPACE " C-m

tmux new-window -t $SESSION:5 -n 'aruco_gate_detector'
tmux send-keys "ros2 launch aruco_gate_detector aruco_gate_detector_launch.py \
    drone_id:=$DRONE_ID_NAMESPACE" C-m

tmux new-window -t $SESSION:6 -n 'realsense_interface'
tmux send-keys "ros2 launch realsense_interface realsense_interface_launch.py \
    drone_id:=$DRONE_ID_NAMESPACE " C-m
    
tmux new-window -t $SESSION:7 -n 'gates to waypoints'
tmux send-keys "ros2 run gates_to_waypoints gates_to_waypoints_node --ros-args -r __ns:=/drone0 " C-m

# TODO:Check rosbag recorder
tmux new-window -t $SESSION:8 -n 'record rosbag'
tmux send-keys "mkdir rosbags && cd rosbags &&\
    ros2 bag record \
    /$DRONE_ID_NAMESPACE/self_localization/odom \
    /$DRONE_ID_NAMESPACE/actuator_command/thrust \
    /$DRONE_ID_NAMESPACE/actuator_command/twist \
    /$DRONE_ID_NAMESPACE/motion_reference/trajectory \
    /$DRONE_ID_NAMESPACE/image_raw \
    /$DRONE_ID_NAMESPACE/aruco_gate_detector/gate_img_topic"

tmux attach-session -t $SESSION:1