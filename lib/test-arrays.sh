#!/bin/bash

source ${HOME}/code/bash/bashLibs/test.sh
source ${HOME}/code/bash/bashLibs/arrays.sh

testArray1=("0" "1" "2" "3" "4") 
declare -a emptyTestArray1
testString1="0,1,2,3,4"

test-convertCSVtoArray() {
    local expectedOutput=$(echo -e "${testArray1[@]}")
    echo -e "\n\n"
    echo -e "Test of function: arrays_convertCSVtoArray:"
    echo -e "=========================================="
    # test_fn "arrays_convertCSVtoArray" "${testString1}" "${expectedOutput}"
    # test_fn "arrays_convertCSVtoArray" '"${testString1}" "testArray1" ","' "${expectedOutput}"
    test_fn "arrays_convertCSVtoArray" "${testString1} ," "${expectedOutput}"
}

time test-convertCSVtoArray
