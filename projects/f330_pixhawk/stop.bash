#!/bin/bash
SESSION=$USER

tmux kill-session -t $SESSION
tmux kill-session -a