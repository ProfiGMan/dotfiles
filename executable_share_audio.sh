#!/bin/bash

trap 'redirect -d' SIGINT

redirect () {
	input_node_id=$(pw-dump | grep -B 25 '"node.description": "telegram' | grep -B 18 "Capture" | grep '"id"' | grep -oP '"id": \K[0-9]+')
	output_list=$(pw-dump | grep -B 27 '"media.class": "Stream/Output/Audio"' | grep '"id"' | grep -oP '"id": \K[0-9]+')
	
	while IFS= read -r line || [[ -n $line ]]; do
		asdf=$(pw-dump $line | grep "telegram")
		if [ -z "${asdf}" ]
		then
			pw-link $1 $line $input_node_id
		fi
	done < <(printf '%s' "$output_list")
}


while :
do
	redirect
done
