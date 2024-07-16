chezmoi_path=$(chezmoi source-path)

home_contents=$(find ~/.config | sed "s:^$(readlink -f ~)::")
chezmoi_contents_raw=$(find $chezmoi_path/dot_config)
chezmoi_contents_processed=$(echo "$chezmoi_contents_raw" | sed -e "s:^$chezmoi_path::" -e 's/executable_//' -e 's/dot_/./g')

home_contents_sorted=$(sort <(echo "$home_contents"))
chezmoi_contents_processed_sorted=$(sort <(echo "$chezmoi_contents_processed"))

difference=$(comm -23 <(echo "$chezmoi_contents_processed_sorted") <(echo "$home_contents_sorted"))

final_list=""
while IFS= read -r line || [[ -n $line ]]; do
	final_list+=$(sed -n "$(grep -n -m 1 $line <(echo "$chezmoi_contents_processed") | cut -f1 -d ":")p" <(echo "$chezmoi_contents_raw"))$'\n'
done < <(printf '%s' "$difference")

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
