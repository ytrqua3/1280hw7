
#initialize headers
headers=$(sed -r '/^[\{\}]$/d' $1 | cut -d"," -f1 | sort | uniq | sed '/^$/d')
columns=()
while read line; do
	columns+=("$line")
done <<<$headers
columns+=(result)
colnums=$(( ${#columns[@]} - 1 ))
#print headers
for i in $(seq 0 $colnums); do
	if [ $i -eq 0 ]; then
		echo -n "${columns[$i]}"
	else
		echo -n ,"${columns[$i]}"
	fi
done
echo

#print data
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
				result=$(echo $result + "${data[$i]}" | bc)
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

