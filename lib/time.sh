#!/bin/bash

########################################
#                                      #
#   Bash Lib for Time and Date stuff   #
#                                      #
########################################

time_dependencies="
date
"
time_timestamp() {
    local option=${1}
    local timestamp=""

    case ${option} in

        "epoch")
            timestamp=$(date '+%s')
        ;;

        "dateAndTime")
            timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
        ;;

        *)
            timestamp=$(date '+%s')
        ;;
    esac

    echo -e "${timestamp}"
}
