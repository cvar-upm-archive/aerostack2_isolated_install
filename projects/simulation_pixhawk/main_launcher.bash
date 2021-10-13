#!/bin/bash

#NUMID_DRONE=1
#NETWORK_ROSCORE=$1

SESSION=$USER

UAV_MASS=1.2
MAV_NAME=iris_simulation

#export AEROSTACK_PROJECT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Kill any previous session (-t -> target session, -a -> all other sessions )
tmux kill-session -t $SESSION
tmux kill-session -a

# Create new session  (-2 allows 256 colors in the terminal, -s -> session name, -d -> not attach to the new session)
tmux -2 new-session -d -s $SESSION

# Create roscore 
# send-keys writes the string into the sesssion (-t -> target session , C-m -> press Enter Button)
tmux rename-window -t $SESSION:0 'RTPS interface'
tmux send-keys -t $SESSION:0 "micrortps_agent -t UDP" C-m

tmux new-window -t $SESSION:1 -n 'pixhawk interface'
tmux send-keys "ros2 run pixhawk_platform pixhawk_platform_node --ros-args -r /drone0/platform/odometry:=/drone0/self_localization/odom" C-m

tmux new-window -t $SESSION:3 -n 'basic behaviours'
tmux send-keys "ros2 launch as2_basic_behaviours basic_behaviours_launch.py" C-m

tmux new-window -t $SESSION:4 -n 'df_controller'
tmux send-keys "ros2 run differential_flatness_based_controller differential_flatness_based_controller_node" C-m

tmux new-window -t $SESSION:5 -n 'traj_generator'
tmux send-keys "ros2 run trajectory_generator trajectory_generator_node" C-m

tmux new-window -t $SESSION:6 -n 'normalize_thrust'
tmux send-keys "ros2 run normalize_thrust normalize_thrust_node" C-m


tmux attach-session -t $SESSION:0
