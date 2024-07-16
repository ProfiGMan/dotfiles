#!/bin/bash
sudo modprobe v4l2loopback
while [ true ]; do wf-recorder --muxer=v4l2 --codec=rawvideo --file=/dev/video0 -x yuv420p; done
