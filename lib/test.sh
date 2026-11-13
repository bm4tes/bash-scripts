#!/bin/bash

test_fn() {
    local allTestArgs=${@}
    function="${1}"
    fnInput="${2}"
    fnExpectedOut="${3}"
    checkMark="✅"
    errorMark="❌"
    fnOut=$(${function} ${fnInput})
    if [[ "${fnOut}" == "${fnExpectedOut}" ]]; then
        echo -e "input: \"${fnInput}\", expected output: \"${fnExpectedOut}\", output: \"${fnOut}\" ${checkMark}"
    else
        echo -e "input: \"${fnInput}\", expected output: \"${fnExpectedOut}\",output: \"${fnOut}\" ${errorMark}"
    fi
}
