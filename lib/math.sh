# Standard library for bash scripts
# containing basic usage functions
#
# Björn Mates
# Started:  07.01.2024
# Latest: 07.01.2024
#
# Version: 0.1
math_dependencies="
    bc
    printf
    sed
"

##############
#            #
#   REGEXS   #
#            #
##############

# NUMBERS
# =======

math_zero_regex="^[-\+]?0+(\.0+)?$"
# math_zero_regex="^[\+-]?0+(\.0+)?$"
math_one_regex="^\+?0*1(\.0+)?$"
math_negativeOne_regex="^-0*1(\.0+)?$"


#################
#               #
#   FUNCTIONS   #
#               #
#################
math_removePlusSign() {
    local inputNumber=$@
    local noPlusSign=$(sed -e "s;+;;g" <<< ${inputNumber})
    echo -e "${noPlusSign}"
}

math_removeLeadingZeros() {
    local inputNumber=$@
    local noPlusSign=$(math_removePlusSign ${inputNumber})
if [[ "${noPlusSign}" =~ ^-?0+\. ]]; then
        # |decimals| < 1
        sed -e "s;0*\.;0.;" <<< ${noPlusSign}
    # elif [[ "${noPlusSign}" == *"."* ]]; then
    elif [[ "${noPlusSign}" =~ ^[-\+]?[1-9]+(\.?[0-9]+)?$ ]]; then
        # |decimals| >= 1
        sed -e "s;0*\([1-9]\+[0-9]*\.\);\1;" <<< ${noPlusSign}
    elif [[ "${noPlusSign}" =~ ^-?0+$ ]]; then
        # |integer| 0
        sed -e "s;-\?0\+;0;" <<< ${noPlusSign}
        # sed -e "s;^-\?0*;0;" <<< ${noPlusSign}
    elif [[ "${noPlusSign}" =~ ${math_zero_regex} ]]; then
        sed -e "s;^-\?0\+\.\(0+\);0.\1;" <<< ${noPlusSign}
    else
        # |integers| > 0
        sed -e "s;\(-\?\)0*\([1-9]\+[0-9]*\);\1\2;" <<< ${noPlusSign}
    fi
}

math_removePlusSignAndLeadingZeros() {
    local inputNumber=${1}
    local noPlusSign=$(math_removePlusSign "${inputNumber}")
    math_removeLeadingZeros "${noPlusSign}"
}

# extracts numbers from array
# removes leading zeros for comparison with bc
math_extractAndFormatNumbersFromArray() {
    local input=("${@}")
    local numbersOnlyArray
    local numberRegex="^[+-]?[0]*[0-9]+.?[0-9]*$"
    for potentialNumber in ${input[@]}; do
        if [[ "${potentialNumber}" =~ ${numberRegex} ]]; then
            potentialNumber=$(math_removeLeadingZeros ${potentialNumber})
            numbersOnlyArray+=("${potentialNumber}")
        fi
    done
    echo "${numbersOnlyArray}"
}

math_min() {
    local inputNumbers=("${@}")
    local smallestNumber=${inputNumbers[0]}
    for number in ${inputNumbers[@]}; do
        local comparison=$(echo "${number} < ${smallestNumber}" | bc)
        if [[ "${comparison}" == "1" ]]; then
            smallestNumber=${number}
        fi
    done
    echo ${smallestNumber}
}

math_max() {
    local inputNumbers=("${@}")
    local largerstNumber=${inputNumbers[0]}
    for number in ${inputNumbers[@]}; do
        local comparison=$(echo "${number} > ${largerstNumber}" | bc)
        if [[ "${comparison}" == "1" ]]; then
            largerstNumber=${number}
        fi
    done
    echo ${largerstNumber}
}

math_extremeNumber() {
    local mode=${1}
    local input=("${@}")
    local numberRegex="^[+-]?[0]*[0-9]+.?[0-9]*$"
    local numbers
    for potentialNumber in ${input[@]}; do
        if [[ "${potentialNumber}" =~ ${numberRegex} ]]; then
            potentialNumber=$(math_removeLeadingZeros ${potentialNumber})
            numbers+=("${potentialNumber}")
        fi
    done
    local extremeNumber=${numbers[0]}
    for number in ${numbers[@]}; do
        if [[ "${mode}" == "min" ]]; then
            local comparison=$(echo "${number} < ${extremeNumber}" | bc)
        elif [[ "${mode}" == "max" ]]; then
            local comparison=$(echo "${number} > ${extremeNumber}" | bc)
        else
            echo -"ERROR: inside math_extremeNumber: syntax: 1st Argument needs to be either min or max!"
        fi
        if [[ "${comparison}" == "1" ]]; then
            extremeNumber=${number}
        fi
    done
    echo ${extremeNumber}
}

# only feed integers
math_parity() {
    local inputNumber=${1}
    local formattedInput=$(math_removePlusSignAndLeadingZeros "${inputNumber}")
    local remainder
    remainder=$(echo "${formattedInput} % 2" | bc)

    if [[ "${remainder}" =~ ${math_zero_regex} ]]
    then
        echo "even"
    elif [[ "${remainder}" =~ ${math_one_regex} ]]
    then
        echo "odd"
    elif [[ "${remainder}" =~ ${math_negativeOne_regex} ]]
    then
        echo "odd"
    else
        echo "undefined"
    fi
}

math_isOne() {
    local inputNumber=$1
    if [[ ${inputNumber} =~ ${math_one_regex} ]]
    then
        echo "true"
    else
        echo "false"
    fi
}
