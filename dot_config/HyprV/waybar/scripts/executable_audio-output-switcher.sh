#!/bin/bash

active_port=$(pactl list sinks | grep "Active Port: analog" | sed 's/^.*analog-output-//')

if [ $active_port == 'lineout' ]; then
	pactl set-sink-port 1 analog-output-headphones
else
	pactl set-sink-port 1 analog-output-lineout
fi
