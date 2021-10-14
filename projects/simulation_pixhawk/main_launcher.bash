#!/bin/bash

#NUMID_DRONE=1
#NETWORK_ROSCORE=$1


if [ -z "$1" ]
then
    if [ -z "$AEROSTACK2_SIMULATION_DRONE_ID" ] 
        then
        echo "no drone id was given, using default drone_id = \"drone101\" "
        DRONE_ID_NAMESPACE="drone101"
    else
        DRONE_ID_NAMESPACE=$AEROSTACK2_SIMULATION_DRONE_ID
    fi
else
DRONE_ID_NAMESPACE=$1
fi

echo "using \"/$DRONE_ID_NAMESPACE/\" namespace"


SESSION=$USER

UAV_MASS=1.5
UAV_MAX_THRUST=10.0

# Kill any previous session (-t -> target session, -a -> all other sessions )
tmux kill-session -t $SESSION
tmux kill-session -a

# Create new session  (-2 allows 256 colors in the terminal, -s -> session name, -d -> not attach to the new session)
tmux -2 new-session -d -s $SESSION

# Create roscore 
# send-keys writes the string into the sesssion (-t -> target session , C-m -> press Enter Button)
tmux rename-window -t $SESSION:0 'RTPS interface'
tmux send-keys -t $SESSION:0 "micrortps_agent -t UDP -n $DRONE_ID_NAMESPACE" C-m

tmux new-window -t $SESSION:1 -n 'pixhawk interface'
tmux send-keys "ros2 launch pixhawk_platform pixhawk_platform_launch.py \
    drone_id:=$DRONE_ID_NAMESPACE \
    mass:=$UAV_MASS \
    max_thrust:=$UAV_MAX_THRUST \
    simulation_mode:=true" C-m

tmux new-window -t $SESSION:2 -n 'df_controller'
tmux send-keys "ros2 launch differential_flatness_based_controller differential_flattness_controller_launch.py \
    drone_id:=$DRONE_ID_NAMESPACE " C-m

tmux new-window -t $SESSION:3 -n 'traj_generator'
tmux send-keys "ros2 launch trajectory_generator trajectory_generator_launch.py  \
    drone_id:=$DRONE_ID_NAMESPACE " C-m

tmux new-window -t $SESSION:4 -n 'follow_path_behaviour'
tmux send-keys "ros2 launch as2_basic_behaviours follow_path_behaviours_launch.py \
    drone_id:=$DRONE_ID_NAMESPACE " C-m


tmux attach-session -t $SESSION:1
