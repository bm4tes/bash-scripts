#!/bin/bash

##################
#                #
#   mastermind   #
#                #
##################

# ==============================================================================
#                                    colors
# ==============================================================================

readonly C_RESET=$(tput sgr0 2> /dev/null || echo "")
readonly C_BLACK=$(tput setaf 0 2> /dev/null || echo "")
readonly C_RED=$(tput setaf 1 2> /dev/null || echo "")
readonly C_GREEN=$(tput setaf 2 2> /dev/null || echo "")
readonly C_YELLOW=$(tput setaf 3 2> /dev/null || echo "")
readonly C_BLUE=$(tput setaf 4 2> /dev/null || echo "")
readonly C_MAGENTA=$(tput setaf 5 2> /dev/null || echo "")
readonly C_CYAN=$(tput setaf 6 2> /dev/null || echo "")
readonly C_WHITE=$(tput setaf 7 2> /dev/null || echo "")

# ==============================================================================
#                                GAME SETTINGS
# ==============================================================================
# codeSymbol="❄"
codeSymbol="●"
correctColorSymbol="○"
board=""
correctColorAndPosiToken="${C_WHITE}${codeSymbol}${C_RESET}"
correctColorToken="${C_WHITE}${correctColorSymbol}${C_RESET}"

colorOptions="
available colors: ${C_RED}${codeSymbol} ${C_GREEN}${codeSymbol} ${C_BLUE}${codeSymbol} ${C_YELLOW}${codeSymbol} ${C_CYAN}${codeSymbol} ${C_MAGENTA}${codeSymbol}${C_RESET}
respective chars: r g b y c m"

colorChars=$(echo -e "${colorOptions}" | tail -1 | awk -F":" '{print $2}' | sed -e "s: ::g")

inputCodePrompt="
Gib den code ein!
Gib \"r\" ein und drücke Enter, um einen zufälligen code zu generieren.
${colorOptions}
"

# ==============================================================================
#                                  FUNCTIONS
# ==============================================================================
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

printKey() {
    echo "------------------------------------------------"
    echo "Key:"
    echo "Correct Color and Position: ${correctColorAndPosiToken}"
    echo "Correct Color:              ${correctColorToken}"
    echo "------------------------------------------------"
}

correctColorAndPosi=0
determineCorrectColorAndPosi() {
    correctColorAndPosi=0
    local code=${1}
    local guess=${2}
    codeResidual=${code}
    guessResidual=${guess}
    for ((i = 0; i < ${#code}; i++)); do
        if [[ "${code:$i:1}" == "${guess:$i:1}" ]]; then
            ((j = i - correctColorAndPosi))
            ((k = j + 1))
            codeResidual=${codeResidual:0:$j}${codeResidual:$k}
            guessResidual=${guessResidual:0:$j}${guessResidual:$k}
            ((correctColorAndPosi++))
        fi
    done
}

determineCorrectColors() {
    correctColors=0
    while [[ "${#guessResidual}" -gt "0" ]]; do
        for ((i = 0; i < ${#codeResidual}; i++)); do
            if [[ "${codeResidual:$i:1}" == "${guessResidual:0:1}" ]]; then
                ((correctColors++))
                ((k = i + 1))
                codeResidual=${codeResidual:0:$i}${codeResidual:$k}
                break # <--- FIX: Halts inner loop to enforce 1:1 peg consumption
            fi
        done
        guessResidual=${guessResidual:1} # Shift to next guess peg
    done
}

rateGuess() {
    local code=${1}
    local guess=${2}
    local output="  "
    determineCorrectColorAndPosi ${code} ${guess}
    determineCorrectColors
    for ((i = 0; i < correctColorAndPosi; i++)); do
        output="${output}${correctColorAndPosiToken} "
    done
    for ((i = 0; i < ${correctColors}; i++)); do
        output="${output}${correctColorToken} "
    done
    echo -e "${output}"
}

displayColors() {
    colCharSeq=$1
    local output=""
    for ((i = 0; i < ${#colCharSeq}; i++)); do
        colChar=${colCharSeq:$i:1}
        case ${colChar} in
            r)
                output="${output}${C_RED}${codeSymbol}${C_RESET} "
                ;;

            g)
                output="${output}${C_GREEN}${codeSymbol}${C_RESET} "
                ;;

            b)
                output="${output}${C_BLUE}${codeSymbol}${C_RESET} "
                ;;

            y)
                output="${output}${C_YELLOW}${codeSymbol}${C_RESET} "
                ;;

            c)
                output="${output}${C_CYAN}${codeSymbol}${C_RESET} "
                ;;

            m)
                output="${output}${C_MAGENTA}${codeSymbol}${C_RESET} "
                ;;

        esac
    done
    echo -e ${output}
}

updateBoard() {
    convertedGuess=$(displayColors ${guess})
    hint=$(rateGuess ${code} ${guess})
    clear
    board="${board}\n${convertedGuess}${hint}"
    echo -e "${board}" | nl
}

generateRandomCode() {
    local codeLength=$1
    code=""
    for ((i = 0; i < codeLength; i++)); do
        code=${code}${colorChars:RANDOM%${#colorChars}:1}
    done
}

##################
#                #
#   GAME START   #
#                #
##################

# ==============================================================================
#                               GAME INIT SETUP
# ==============================================================================

affirmation="0"
while [[ "${affirmation}" != "" ]]; do
    echo -e "${inputCodePrompt}"
    read code
    stdLib_validateInput "[${colorChars}]+" ${code} "${inputCodePrompt}"
    code=${stdLib_validatedInput}
    if [[ "${code}" == "r" ]]; then
        echo -e "Wieviele Stellen soll der code haben?:"
        read places
        generateRandomCode ${places}
        break
    fi
    echo -e "Du hast folgenden code eingegeben:"
    displayColors ${code}
    echo -e "Drücke ENTER, um zu bestätigen."
    echo -e "Gib etwas anderes ein und drücke ENTER, um den code neu einzugeben."
    read affirmation
done
clear

guessPrompt="Rate mal!:\n
Gib ${#code} Buchstaben entsprechend der Farben ein!\n
${colorOptions}
"

# ==============================================================================
#                                  GAME LOOP
# ==============================================================================
while [[ "${guess}" != "${code}" ]]; do
    printKey
    echo -e "${guessPrompt}"
    read guess
    stdLib_validateInput "^[${colorChars}]{${#code}}$" ${guess} "${guessPrompt}"
    guess=${stdLib_validatedInput}
    updateBoard
done
