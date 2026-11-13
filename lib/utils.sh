# Utilitylibrary for bash scripts
# containing basic usage functions
#
# Björn Mates
# Started:  17.10.2023
# Latest: 17.10.2023
#
# Version: 0.1

utilsLib_pluralize() {
	local amount=${1}
	local singular=${2}
	local plural=${3}
    if [[ "${amount}" -ne 1 ]]
	then
	    echo "${plural}"
	else
	    echo "${singular}"
	fi
}

utilsLib_weightedCoinFlip() {
    # 0 <= num <= 9
    div=$1
    randomNumber=${numbers:RANDOM%${#numbers}:1}
    if [[ "${randomNumber}" -lt "${div}" ]]; then
        output="heads"
    else
        output="tails"
    fi
    echo "${output}"
}

utilsLib_backupCopy() {
    files="${@}"
    timestamp=$(date +%s)
    for file in ${files}; do
        filePath=$(realpath ${file})
        cp -r ${filePath} ${filePath}.${timestamp}.bak
    done
}
