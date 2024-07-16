chezmoi_path=$(chezmoi source-path)
home_path=$(readlink -f ~)

chezmoi_contents_raw=$(find $chezmoi_path)
chezmoi_contents_processed=$(echo "$chezmoi_contents_raw" | sed -e "s:^$chezmoi_path::" -e 's/executable_//' -e 's/dot_/./g')

final_list=""
while IFS= read -r line || [[ -n $line ]]; do
	if [[ "$line" == "/.git"* ]]; then
		continue
	fi

	if [ ! -e $home_path$line ]; then
		final_list+=$(sed -n "$(grep -n -m 1 $line <(echo "$chezmoi_contents_processed") | cut -f1 -d ":")p" <(echo "$chezmoi_contents_raw"))$'\n'
	fi
done < <(printf '%s' "$chezmoi_contents_processed")

if [[ -z "$final_list" ]]; then
	echo "No files that should be removed are found"
	exit 0
fi

echo "$final_list"

read -r -p "Are you sure you want to delete these? [y/N] " response
response=${response,,} # tolower
if [[ "$response" =~ ^(yes|y)$ ]]; then
	echo "$final_list" | xargs rm -rf
else
	echo "Doing nothing"
	exit 0
fi

echo "Finished deleting"
