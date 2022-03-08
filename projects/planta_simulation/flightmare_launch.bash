#!/bin/bash

# Flightros
FLIGHTMARE_SCENE=5 # PLANTA
ros2 launch flightros flight_pilot_launch.py drone_id:=$AEROSTACK2_SIMULATION_DRONE_ID scene_id:=$FLIGHTMARE_SCENE