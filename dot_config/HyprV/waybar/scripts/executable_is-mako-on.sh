#!/bin/bash

if [ "$(makoctl mode)" == "silent" ]; then
	echo 🌜
else
	echo ""
fi
