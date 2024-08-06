#!/bin/bash

active_port=$(pactl list sinks | grep "Active Port: analog" | sed 's/^.*analog-output-//')
sink=$(pactl list sinks | grep -B 1 "State: RUNNING" | sed -n -e 's/Sink #//p')

if [ $active_port == 'lineout' ]; then
	pactl set-sink-port $sink analog-output-headphones
else
	pactl set-sink-port $sink analog-output-lineout
fi
