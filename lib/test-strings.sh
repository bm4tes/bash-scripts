#!/bin/bash

source ${HOME}/code/bash/bashLibs/test.sh
source ${HOME}/code/bash/bashLibs/strings.sh

test-strings_shuffle() {
    input1=""
    input2="1234"
    output0=$(strings_shuffle ${input1})
    output1=$(strings_shuffle ${input2})
    output2=$(strings_shuffle ${input2})
    output3=$(strings_shuffle ${input2})
    output4=$(strings_shuffle ${input2})
    output5=$(strings_shuffle ${input2})
    output6=$(strings_shuffle ${input2})
    output7=$(strings_shuffle ${input2})
    echo -e "\n\n"
    echo -e "Test of function: strings_shuffle:"
    echo -e "=================================="
    echo -e "input: \"${input1}\"   - output: ${output0}"
    echo -e "input: \"${input2}\"   - output: ${output1}"
    echo -e "input: \"${input2}\"   - output: ${output2}"
    echo -e "input: \"${input2}\"   - output: ${output3}"
    echo -e "input: \"${input2}\"   - output: ${output4}"
    echo -e "input: \"${input2}\"   - output: ${output5}"
    echo -e "input: \"${input2}\"   - output: ${output6}"
    echo -e "input: \"${input2}\"   - output: ${output7}"
}

time test-strings_shuffle
