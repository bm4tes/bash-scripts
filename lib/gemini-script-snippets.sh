#!/bin/bash
# 

# Boilerplate for safe colors
# --- Color Definitions ---
if [[ -t 1 ]]; then
	BOLD=$'\\e[1m'
	RESET=$'\\e[0m'
	BOLD_RED=$'\\e[1;31m'
	BOLD_YELLOW=$'\\e[1;33m'
else
	BOLD=""
	RESET=""
	BOLD_RED=""
	BOLD_YELLOW=""
fi


usage() {
	cat <<-EOF
	${BOLD}USAGE${RESET}
	  ${1:$(basename "$0")} [options] <arguments>

	${BOLD}DESCRIPTION${RESET}
	  ${2:Description of the script.}

	${BOLD}OPTIONS${RESET}
	  -h, --help    Show this help message
	EOF
	exit 1
}

# --- Your Request: error() ---
# (Robust 'error' function using printf and color variables)
error() {
	# Print the error message (all arguments) to stderr
	printf "%s\\n" "${BOLD_RED}ERROR:${RESET} $*" >&2
	exit 1
}

# (Partner function 'warn' - does not exit)
warn() {
	# Print the warning (all arguments) to stderr
	printf "%s\\n" "${BOLD_YELLOW}WARNING:${RESET} $*" >&2
}


# ================================================================
#  Argument Parsing Snippets
# ================================================================

#!/usr/bin/env bash
#
# A script template for the POSIX 'getopts' built-in.
#
set -euo pipefail

# The leading colon ':' enables "silent" error handling,
# allowing us to manually handle errors.
while getopts ":hf:v" opt; do
    case $opt in
        h)
            # Handle the -h (help) option
            usage
            ;;
        f)
            # Handle the -f (file) option
            # $OPTARG contains the argument passed to -f
            INPUT_FILE="$OPTARG"
            ;;
        v)
            # Handle the -v (verbose) flag
            VERBOSE=1
            ;;
        \?)
            # Handle invalid options
            echo "Error: Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            # Handle missing arguments
            echo "Error: Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# 'shift' removes the options that 'getopts' has processed.
# This leaves only the "remaining" arguments in $@.
shift $((OPTIND - 1))


####################
#                  #
#   BASH GETOPTS   #
#                  #
####################

# --- Configuration ---
INPUT_FILE=""
VERBOSE=0



# 1. Define your options
SHORT_OPTS="hf:v"
LONG_OPTS="help,file:,verbose"

# 2. Parse the options
# The 'getopt' command rewrites the arguments.
# '-n' sets the name for error messages.
# '--' separates getopt options from script arguments.
PARSED_OPTS=$(getopt -o "$SHORT_OPTS" --long "$LONG_OPTS" -n "$(basename "$0")" -- "$@")

# Check if getopt failed (e.g., invalid option)
if [[ $? -ne 0 ]]; then
    usage
fi

# 3. Apply the parsed options to the shell's argument list
# This 'eval' is critical and safe in this context.
eval set -- "$PARSED_OPTS"

# 4. Loop through the parsed options
while true; do
    case "$1" in
        -h|--help)
            usage
            ;;
        -f|--file)
            INPUT_FILE="$2"
            shift 2 # Consume option and argument
            ;;
        -v|--verbose)
            VERBOSE=1
            shift # Consume option
            ;;
        --)
            # This is the end-of-options marker
            shift # Consume the '--'
            break # Exit the loop
            ;;
        *)
            # This should not happen if getopt parsing was successful
            echo "Internal Error: Unhandled option: $1" >&2
            exit 1
            ;;
    esac
done

# --- Program Start ---

echo "--- Configuration ---"
echo "Verbose: $VERBOSE"
echo "Input File: $INPUT_FILE"
echo "Remaining Args: $@"
echo "---------------------"

if [[ -z "$INPUT_FILE" ]]; then
    echo "Error: No input file specified." >&2
    usage
fi

echo "Processing file: $INPUT_FILE"
# ... rest of your script ...
