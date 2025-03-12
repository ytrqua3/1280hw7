headers=$(sed -r '/^[\{\}]$/d' $1 | cut -d"," -f1 | sort | uniq | tr "\n" " ")

read -a columns <<<$headers
columns+=(result)
colnums=$(( ${#columns[@]} - 1 ))
echo ${columns[@]} | tr " " ","

while read line; do
	if [[ $line == "{" ]]; then
		data=()
		for i in ${columns[@]}; do
			data+=(0)
		done
	elif [[ $line == "}" ]]; then
		result=0
		for i in $(seq 0 $(( $colnums - 1 ))); do
			echo -n "${data[$i]}",
			if echo "${columns[$i]}" | grep -q $2; then
				result=$(( $result + "${data[$i]}" ))
			fi
		done
		echo $result
	else
		for i in $(seq 0 $colnums); do
			if echo $line | grep -q "${columns[$i]}"; then
				data[$i]=$(echo $line | cut -d"," -f2)
			fi
		done
	fi
done <$1

