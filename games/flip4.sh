#!/bin/bash

# sources generic stuff like libs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/standardBashLib.sh"
source "${SCRIPT_DIR}/../lib/colors.sh"
source "${SCRIPT_DIR}/../lib/strings.sh"
source "${SCRIPT_DIR}/../lib/arrays.sh"
source "${SCRIPT_DIR}/../lib/time.sh"

dependencies="
tr
sort
uniq
rev
bc
getopts
${time_dependencies}
${strings_dependencies}
"

stdLib_checkDependencies ${dependencies}

redSaveString="red"
yellowSaveString="yellow"
blueSaveString="blue"
greenSaveString="green"
gameOver="false"
declare -a players
declare -a playerColors
playerColors=("${redSaveString}" "${yellowSaveString}" "${blueSaveString}" "${greenSaveString}")
declare -a playerColorCodes
# colors assigned by default
playerColorCodes=(${redf} ${yellowf} ${cyanf} ${greenf})
declare -a board
declare -a winners
declare -a winningCoordinates
boardWidth=8
boardHeight=6
flipCommand="f"
saveCommand="s"
quitCommand="q"
winningCondition=4

# for loaded games or CLI options start
initPlayerColors() {
    unset playerColors
    unset playerColorCodes
    local playerColorList=${@}
    for color in ${playerColorList}; do
        case ${color} in

            "${redSaveString}")
                playerColors+=("${redSaveString}")
                playerColorCodes+=("${redf}")
                ;;

            "${yellowSaveString}")
                playerColors+=("${yellowSaveString}")
                playerColorCodes+=("${yellowf}")
                ;;

            "${blueSaveString}")
                playerColors+=("${blueSaveString}")
                playerColorCodes+=("${bluef}")
                ;;

            "${greenSaveString}")
                playerColors+=("${greenSaveString}")
                playerColorCodes+=("${greenf}")
                ;;

        esac
    done
}

#####################
#                   #
#   GAME SETTINGS   #
#                   #
#####################
minPlayers=2
maxPlayers=4
minBoardWidth=8
maxBoardWidth=9
minBoardHeight=6
maxBoardHeight=12
defaultBoardWidth=8
defaultBoardHeight=6
randomOrder="false"

actionCounter=0
activePlayerID=0
columnDividerChar="│"

min() {
    if [[ ${1} -lt ${2} ]]; then
        echo "${1}"
    else
        echo "${2}"
    fi
}

updateActivePlayerID() {
    let activePlayerID=${actionCounter}%${#players[@]}
}

tokenChar="●" # unicode 25cf - black circle
# emptyCharCol=" "
emptyCharBoard=""

randomizeTurnSequence() {
    local randomIndexList=$(arrays_randomIndexList "${players[@]}")
    arrays_rearrange "players" "randomIndexList"
    unset players
    players=("${arrays_rearrangedArray[@]}")
    arrays_rearrange "playerColors" "randomIndexList"
    unset playerColors
    playerColors=("${arrays_rearrangedArray[@]}")
    arrays_rearrange "playerColorCodes" "randomIndexList"
    unset playerColorCodes
    playerColorCodes=("${arrays_rearrangedArray[@]}")
}

initializePlayers() {
    local inputPrompt="
    Wie viele Spieler möchten spielen?
    "
    local errorPrompt="
    Gib eine Zahl zwischen ${minPlayers} und ${maxPlayers} ein:
    "
    local errorPromptName="
    Der Name darf nur Buchstaben, Zahlen und Leerzeichen enthalten,
    und muss mindestens 1 lang sein!
    "
    clear
    echo -e "${inputPrompt}${errorPrompt}"
    read noOfPlayers
    stdLib_validateInput "^[${minPlayers}-${maxPlayers}]$" "${noOfPlayers}" "${errorPrompt}"
    noOfPlayers=${stdLib_validatedInput}
    for ((i = 1; i <= ${noOfPlayers}; i++)); do
        clear
        echo -e "    Gib den Namen von Spieler ${i} ein:"
        read playerName
        stdLib_validateInput "[[:alnum:]\ ]+" "${playerName}" "${errorPromptName}"
        playerName="${stdLib_validatedInput}"
        players+=("${playerName}")
    done
}

flipBoard() {
    for ((i = 0; i < ${boardWidth}; i++)); do
        reversedCol=$(echo "${board[${i}]}" | rev)
        board[${i}]=${reversedCol}
    done
}

placeToken() {
    colNum=$1
    local colIndex
    let "colIndex = ${colNum} - 1"
    colString=""
    colString=${board[${colIndex}]}
    colString=${colString}${activePlayerID}
    board[${colIndex}]=${colString}
}

playerAction() {
    local prompt="Gib eine Zahl zwischen 1 und ${boardWidth} ein,"
    prompt="${prompt}\num einen Spielstein darin abzulgen,"
    prompt="${prompt}\noder \"${flipCommand}\" um das Spielfeld umzudrehen,"
    prompt="${prompt}\noder \"${saveCommand}\" um den Spielstand mit einem Timesamp im aktuellen Verzeichnis zu speichern,"
    prompt="${prompt}\noder \"${quitCommand}\" um zu speichern und das Spiel zu verlassen."
    echo -e "${prompt}"
    local colHeight=${boardHeight}
    while [[ ${colHeight} -ge ${boardHeight} ]]; do
        read action
        stdLib_validateInput "^[1-${boardWidth}]$|^${flipCommand}$|^${saveCommand}$|^${quitCommand}$" "${action}" "${prompt}"
        action=${stdLib_validatedInput}
        case ${action} in
            "${flipCommand}")
                ((actionCounter++))
                flipBoard
                break
                ;;

            "${saveCommand}")
                saveGame
                break
                ;;

            "${quitCommand}")
                saveGame
                exit
                ;;

            *)
                local colIndex
                let "colIndex = action - 1"
                col=${board[${colIndex}]}
                colHeight=${#col}
                if ((${colHeight} < ${boardHeight})); then
                    ((actionCounter++))
                    placeToken ${action}
                else
                    echo "Die Spalte ist schon voll, wähle eine andere Aktion!"
                fi
                ;;
        esac
    done
}

makePoint() {
    local indecies=("${@}")
    local point="("
    for index in ${indecies}; do
        point="${point}${index},"
    done
    point="${point})"
    point=$(
        echo "${point}" |
            sed -e "s/,)/)/"
    )
    echo "${point}"
}

colorize() {
    local inputPlayerID=$1
    local color=${playerColorCodes[${inputPlayerID}]}
    if [[ "${inputPlayerID}" == "${emptyCharBoard}" ]]; then
        echo ${emptyCharBoard}
    else
        echo -e "${color}${tokenChar}${reset}"
    fi
}

colorizeWinCell() {
    local inputPlayerID=$1
    local color=${playerColorCodes[${inputPlayerID}]}
    echo -e "${color}${blinkOn}${tokenChar}${reset}"
}

printBoard() {
    topBorder="┌"
    bottomBorder="└"
    columnNumbering=" "
    for ((i = 1; i <= ${boardWidth}; i++)); do
        if [[ "${i}" == "${boardWidth}" ]]; then
            topBorder="${topBorder}─┐"
            bottomBorder="${bottomBorder}─┘"
        else
            topBorder="${topBorder}─┬"
            bottomBorder="${bottomBorder}─┴"
        fi
        columnNumbering="${columnNumbering}${i} "
    done

    boardPrintString="${columnNumbering}"
    boardPrintString="${bottomBorder}\n${boardPrintString}"

    for ((j = 0; j < ${boardHeight}; j++)); do
        nextRow="${columnDividerChar}"
        for ((i = 0; i < ${boardWidth}; i++)); do
            nextCellPlayerID=${board[$i]:$j:1}
            coordinates=$(makePoint "${i} ${j}")
            isWinningCell=$(arrayContains ${winningCoordinates[@]} ${coordinates})
            if [[ "${gameOver}" == "true" && ${isWinningCell} -gt 0 ]]; then
                nextCellEntry=$(colorizeWinCell ${nextCellPlayerID})
            else
                nextCellEntry=$(colorize ${nextCellPlayerID})
            fi

            if [[ "${nextCellEntry}" == "${emptyCharBoard}" ]]; then
                nextCell=" ${columnDividerChar}"
            else
                nextCell="${nextCellEntry}${columnDividerChar}"
            fi

            nextRow=${nextRow}${nextCell}
        done
        boardPrintString="${nextRow}\n${boardPrintString}"
    done
    boardPrintString="${topBorder}\n${boardPrintString}"
    echo -e "${boardPrintString}"
}

printPlayers() {
    for ((i = 0; i < ${#players[@]}; i++)); do
        local color=${playerColorCodes[${i}]}
        local coloredPlayer=${color}${players[$i]}${reset}
        if [[ "${i}" == "${activePlayerID}" ]]; then
            echo -e "* ${coloredPlayer}"
        else
            echo -e "  ${coloredPlayer}"
        fi
    done
}

refreshScreen() {
    clear
    printPlayers
    printBoard
}

declare -a streak
declare -a pointStreak
declare -a streakMirrored
declare -a pointStreakMirrored
buildStreak() {
    local streakSelector=$1
    local point=$2
    local newCellContent=$3
    declare -a buildingStreak
    declare -a buildingPointStreak
    if [[ "${streakSelector}" == "1" ]]; then
        buildingStreak=("${streak[@]}")
        buildingPointStreak=("${pointStreak[@]}")
    elif [[ "${streakSelector}" == "2" ]]; then
        buildingStreak=("${streakMirrored[@]}")
        buildingPointStreak=("${pointStreakMirrored[@]}")
    fi

    if [[ "${newCellContent}" != "" && "${newCellContent}" == "${buildingStreak[0]}" ]]; then
        buildingStreak+=("${newCellContent}")
        buildingPointStreak+=("${point}")
    elif [[ "${newCellContent}" != "" && "${newCellContent}" != "${buildingStreak[0]}" ]]; then
        unset buildingStreak
        unset buildingPointStreak
        buildingStreak+=("${newCellContent}")
        buildingPointStreak+=("${point}")
    else
        unset buildingStreak
        unset buildingPointStreak
    fi

    if [[ "${streakSelector}" == "1" ]]; then
        streak=("${buildingStreak[@]}")
        pointStreak=("${buildingPointStreak[@]}")
    elif [[ "${streakSelector}" == "2" ]]; then
        streakMirrored=("${buildingStreak[@]}")
        pointStreakMirrored=("${buildingPointStreak[@]}")
    fi
}

addWinner() {
    if [[ ${#streak[@]} -ge ${winningCondition} ]]; then
        winners+=("${streak[0]}")
        winningCoordinates+=("${pointStreak[@]}")
        gameOver="true"
    fi

    if [[ ${#streakMirrored[@]} -ge ${winningCondition} ]]; then
        winners+=("${streakMirrored[0]}")
        winningCoordinates+=("${pointStreakMirrored[@]}")
        gameOver="true"
    fi
}

mirrorIndex() {
    local arraySize=${1}
    local indexToConvert=${2}
    echo "${arraySize} - 1 - ${indexToConvert}" | bc
}

checkWin() {
    # array containing player indices of winners
    # aka playerID
    # check vertical 4
    # Hier werden Zeilen geprüft
    for ((i = 0; i < ${boardWidth}; i++)); do
        unset streak
        unset pointStreak
        for ((j = 0; j < ${boardHeight}; j++)); do
            this=${board[$i]:$j:1}
            coordinates=$(makePoint "$i $j")
            buildStreak 1 ${coordinates} ${this}
            addWinner
        done
    done

    # check horizontal
    for ((j = 0; j < ${boardHeight}; j++)); do
        unset streak
        unset pointStreak
        for ((i = 0; i < ${boardWidth}; i++)); do
            this=${board[$i]:$j:1}
            coordinates=$(makePoint "$i $j")
            buildStreak 1 ${coordinates} ${this}
            addWinner
        done
    done

    #check diagonals
    # check col1 upwards first
    for ((k = 0; k <= ${boardHeight} - ${winningCondition}; k++)); do
        unset streak
        unset pointStreak
        unset streakMirrored
        unset pointStreakMirrored
        i=0
        mirroredIindex=$(mirrorIndex ${boardWidth} ${i})
        for ((j = ${k}; j < ${boardHeight}; j++)); do
            this=${board[$i]:$j:1}
            coordinates=$(makePoint "$i $j")
            coordinatesMirrored=$(makePoint "$mirroredIindex $j")
            buildStreak 1 ${coordinates} ${this}
            thisMirrored=${board[${mirroredIindex}]:$j:1}
            buildStreak 2 ${coordinatesMirrored} ${thisMirrored}
            addWinner
            ((i++))
        done
    done

    for ((k = 1; k <= ${boardWidth} - ${winningCondition}; k++)); do
        unset streak
        unset pointStreak
        unset streakMirrored
        unset pointStreakMirrored
        i=${k}
        mirroredIindex=$(mirrorIndex ${boardWidth} ${i})
        let "stepsToRightEnd = ${boardWidth} - ${k} - 1"
        steps=$(min ${boardHeight} ${stepsToRightEnd})
        for ((j = 0; j < ${steps}; j++)); do
            this=${board[$i]:$j:1}
            coordinates=$(makePoint "$i $j")
            coordinatesMirrored=$(makePoint "$mirroredIindex $j")
            buildStreak 1 ${coordinates} ${this}
            thisMirrored=${board[${mirroredIindex}]:$j:1}
            buildStreak 2 ${coordinatesMirrored} ${thisMirrored}
            addWinner
            ((i++))
            ((mirroredIindex--))
        done
    done
}

arrayContains() {
    local inputArray=("${@}")
    local inputTestString=${inputArray[-1]}
    local counter=0
    for element in "${inputArray[@]}"; do
        if [[ "${element}" == "${inputTestString}" ]]; then
            ((counter++))
        fi
    done
    ((counter--))
    echo ${counter}
}

uniqueArray() {
    local inputArray=("${@}")
    echo "${inputArray[@]}" | tr " " "\n" | sort | uniq
}

gameLoop() {
    while [[ ${#winners[@]} -eq 0 ]]; do
        playerAction
        checkWin
        updateActivePlayerID
        refreshScreen
        # saveGame
    done
}

gameOver() {
    echo -e "\nGAME OVER"
    echo ""
    echo -e "Gewinner:"
    uniqueWinners=$(uniqueArray "${winners[@]}")
    for winner in ${uniqueWinners}; do
        echo "${players[${winner}]}"
    done
}

initNewGame() {
    initializePlayers
    randomizeTurnSequence
    # initializeBoard
}

noEntrySaveString="empty"
saveGame() {
    local gameState
    # activePlayerID
    gameState="activePlayerID:${activePlayerID}\n"
    # actionCounter
    gameState="${gameState}actionCounter:${actionCounter}\n"
    # players
    for player in ${players[@]}; do
        gameState="${gameState}player:${player}\n"
    done
    # boardHeight
    gameState="${gameState}boardHeight:${boardHeight}\n"
    # boardWidth
    gameState="${gameState}boardWidth:${boardWidth}\n"
    # board
    for ((i = 0; i < ${boardWidth}; i++)); do
        let "j = i + 1"
        col=${board[${i}]}
        if [[ "${col}" == "" ]]; then
            col=${noEntrySaveString}
        fi
        gameState="${gameState}boardCol${j}:${col}\n"
    done
    # winning condition
    gameState="${gameState}winningCondition:${winningCondition}\n"
    # colors
    for ((i = 0; i < ${#players[@]}; i++)); do
        gameState="${gameState}playerColor:${playerColors[$i]}\n"
    done
    local fileName=$(time_timestamp "dateAndTime")
    fileName=${fileName}-flip4.sh.saveGame

    echo -e "${gameState}" > ${fileName}
}

createListFromSaveFile() {
    local saveFilePath=$1
    local keyword=$2
    local gameState=$(cat "${saveFilePath}")
    local entryList=$(
        echo -e "${gameState}" |
            sed -ne "/${keyword}/p" |
            awk -F: '{ print $2 }'
    )
    echo -e "${entryList}"
}

# echo -e "DEBUG: createListfromsavefeile players keyword:"
# createListFromSaveFile $1 "board:" # DEBUG

extractKeyValueFromSaveFile() {
    local saveFilePath=$1
    local keyword=$2
    local gameState=$(cat "${saveFilePath}")
    local keyValue=$(
        echo -e "${gameState}" |
            sed -ne "/${keyword}/p" |
            awk -F: '{ print $2 }'
    )
    echo -e "${keyValue}"
}

loadGame() {
    local saveFilePath=$1
    local gameState=$(cat "${saveFilePath}")
    activePlayerID=$(extractKeyValueFromSaveFile ${saveFilePath} "activePlayerID")
    actionCounter=$(extractKeyValueFromSaveFile ${saveFilePath} "actionCounter")
    local playerList=$(createListFromSaveFile ${saveFilePath} "player:")
    local i=0
    for player in ${playerList}; do
        players[$i]=${player}
        ((i++))
    done
    local playerColorList=$(createListFromSaveFile ${saveFilePath} "playerColor:")
    local i=0
    initPlayerColors "${playerColorList}"
    boardWidth=$(extractKeyValueFromSaveFile ${saveFilePath} "boardWidth")
    boardHeight=$(extractKeyValueFromSaveFile ${saveFilePath} "boardHeight")
    winningCondition=$(extractKeyValueFromSaveFile ${saveFilePath} "winningCondition")
    local colList=$(createListFromSaveFile ${saveFilePath} "boardCol")
    local i=0
    for col in ${colList}; do
        if [[ "${col}" != "${noEntrySaveString}" ]]; then
            board[$i]=${col}
        fi
        ((i++))
    done
}

##################
#                #
#   Game Start   #
#                #
##################

saveFile=$1
# no arguments given
if [ -z ${1} ]; then
    initNewGame
# exactly 1 argument given --> save file
elif [ "$#" -eq 1 ]; then
    if [ -f "${saveFile}" ]; then
        loadGame ${saveFile}
    else
        echo "${saveFile} does not exist."
        exit 1
    fi
# more than 1 arguments --> parse options
else
    declare -a cliColors=()
    while getopts p:c:g:w:h:r flag; do
        case "${flag}" in
            p) players+=("${OPTARG}") ;;
            c) cliColors+=("${OPTARG}") ;;
            g) winningCondition="${OPTARG}" ;;
            w) boardWidth="${OPTARG}" ;;
            h) boardHeight="${OPTARG}" ;;
            r) randomOrder="${OPTARG}" ;;
        esac
    done
    if [ ${#cliColors[@]} -gt 0 ]; then
        initPlayerColors "${cliColors[@]}"
    fi
    # while getopts p:c:g:w:h:r flag; do
    #     case "${flag}" in
    #         p) players+=("${OPTARG}") ;;
    #         c) playerColorListReversed="${OPTARG}\n${playerColorListReversed}" ;;
    #         g) winningCondition="${OPTARG}" ;;
    #         w) boardWidth="${OPTARG}" ;;
    #         h) boardHeight="${OPTARG}" ;;
    #         r) randomOrder="${OPTARG}" ;;
    #     esac
    # done
    # playerColorList=$(echo -e ${playerColorListReversed} | tac)
    # noOfPlayerColors=$(echo -e "${playerColorList}" | wc -l)
    # if [ ${noOfPlayerColors} -gt 0 ]; then
    #     initPlayerColors "${playerColorList}"
    # fi
fi

if [[ "${randomOrder}" != "false" ]]; then
    randomizeTurnSequence
fi

refreshScreen

gameLoop

gameOver

# echo "DEBUG: Winning Coordinates: ${winningCoordinates[@]}"
