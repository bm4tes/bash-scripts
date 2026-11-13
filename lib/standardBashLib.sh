# Standard library for bash scripts
# containing basic usage functions
#
# Björn Mates
# Started:  17.10.2023
# Latest: 17.10.2023
#
# Version: 0.1

stdLib_passedVarsToScript=${@}

######################
#                    #
#   Help And Usage   #
#                    #
######################

# usage: displayHelp "${@}" "<help message>"
stdLib_displayHelp() {
  helpOptionStrings="-h --help"
	local helpMessage=${2}
	for option in ${helpOptionStrings}
	do
	    if [[ "${stdLib_passedVarsToScript}" == "${option}" ]]
		then
		  echo -e "${helpMessage}"
			exit 0
		fi
	done
}

##########################
#                        #
#   Dependencies Check   #
#                        #
##########################

stdLib_errorPrefix="Error: "

stdLib_checkCommandAvailable () {
	if ! command -v ${1} &> /dev/null
    then
    echo "${stdLib_errorPrefix}${1} could not be found"
		((noOfmissingCommands++))
    fi
}

stdLib_checkDependencies () {
  local noOfmissingCommands=0
	for command in "${@}"
	do
	    stdLib_checkCommandAvailable ${command}
	done
	if [[ "${noOfmissingCommands}" -gt 0 ]]
	then
	  echo -e "Aborting. Please install the missing commands."
		exit 1
	fi
}

stdLib_exitAndPrintMessageIfNoArgs() {
	local message=${1}
	if [[ -z "${stdLib_passedVarsToScript}" ]]; then
    echo -e "${message}"
    exit
  fi
}

########################
#                      #
#   Input Validation   #
#                      #
########################

#=== Positive Intgers ===#
stdLib_validatedPosInt=0
stdLib_posIntPromptAndCheck () {
    local check=${1}
    while [[ ! "$check" =~ ^[0-9]+$ ]]; do
        posIntPrompt="Gib eine positive ganze Zahl ein!"
        # intErrorPrompt
        echo ${posIntPrompt}
        read check
    done
    stdLib_validatedPosInt=${check}
}

stdLib_validatedInput=""
stdLib_validateInput() {
    local regex=$1
    local input=$2
	  local errorPrompt=$3
    while [[ ! "${input}" =~ ${regex} ]]; do
        echo -e ${errorPrompt}
        read input
    done
    stdLib_validatedInput="${input}"
}

#######################
#                     #
#   files and paths   #
#                     #
#######################

stdLib_check_file_exist() {
	PATH_TO_CHECK="${1}"

	if [ ! -e "${PATH_TO_CHECK}" ]; then
	    echo "Error: Path '${PATH_TO_CHECK}' does not exist." >&2
	    exit 1
	fi
}
