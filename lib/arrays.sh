# does not work for sparse arrays
# newArray=($(arrays_reverse "${inputArray[@]}"))
arrays_reverse() {
    local inputArray=("$@")
    local min=0
    local max=${#inputArray[@]}; ((max--))

    while [[ "$min" -lt "$max" ]]
    do
        # Swap current first and last elements
        local x="${inputArray[$min]}"
        inputArray[$min]="${inputArray[$max]}"
        inputArray[$max]="${x}"

        # Move closer
        (( min++, max-- ))
    done
    echo "${inputArray[*]}"
}

arrays_convertToCSV() {
    local -n inputArrayVarName=${1}
    local arraySize=${2}
    local separator=${3}
    local csvString
    for ((i = 0 ; i < ${arraySize} ; i++)); do
        if [[ ${i} -eq 0 ]]; then
            csvString="${inputArrayVarName[${i}]}"
        else
            csvString="${csvString}${separator}${inputArrayVarName[${i}]}"
        fi
    done
    echo -e "${csvString}"
}

arrays_convertCSVtoArray() {
    local inputString=${1}
    local separator=${2}
    local outputArray
    entries=$(echo ${inputString} |\
        awk -F${separator} '{
            for (i = 1; i <= NF; i++){
              print $i
            }
        }'
    )

    for entry in ${entries}; do
        outputArray+=("${entry}")
    done

    echo -e "${outputArray[@]}"
}

arrays_randomIndexList() {
    local inputArray=("$@")
    local arraySize=${#inputArray[@]}
    local indexList=""
    for ((i = 0 ; i < ${arraySize} ; i++)); do
        if [[ $i -eq 0 ]]; then
            indexList="${i}"
        else
            indexList="${indexList}\n${i}"
        fi
    done
    randomIndexList=$(echo -e ${indexList} | shuf)
    echo -e ${randomIndexList}
}

declare -a arrays_shuffledArray
arrays_shuffle() {
    unset arrays_shuffledArray
    local inputArray=("$@")
    # local arraySize=${#inputArray[@]}
    randomIndexList=$(arrays_randomIndexList "${inputArray[@]}")
    for index in ${randomIndexList}; do
        arrays_shuffledArray+=("${inputArray[${index}]}")
    done
}

arrays_rearrange_indexList=""
declare -a arrays_rearrangedArray
arrays_rearrange() {
    unset arrays_rearrangedArray
    local -n inputArrayVarName=${1}
    local -n inputIndexListVarName=${2}
    # local inputArray=("$@")
    for index in ${inputIndexListVarName}; do
        arrays_rearrangedArray+=("${inputArrayVarName[${index}]}")
    done
}

# toll() {
#     local -n inputArrayVarName=${1}
#     arrays_shuffle "${inputArrayVarName[@]}"
#     unset ${inputArrayVarName}
#     ${inputArrayVarName}=("${arrays_shuffledArray[@]}")
# }
