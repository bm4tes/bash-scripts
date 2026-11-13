#                         88
#                         88
#                         88
#   ,adPPYba,  ,adPPYba,  88  ,adPPYba,  8b,dPPYba, ,adPPYba,
#  a8"     "" a8"     "8a 88 a8"     "8a 88P'   "Y8 I8[    ""
#  8b         8b       d8 88 8b       d8 88          `"Y8ba,
#  "8a,   ,aa "8a,   ,a8" 88 "8a,   ,a8" 88         aa    ]8I
#   `"Ybbd8"'  `"YbbdP"'  88  `"YbbdP"'  88         `"YbbdP"'

colorsLib_escapeChar=$'\033'

blackf="${colorsLib_escapeChar}[30m"
redf="${colorsLib_escapeChar}[31m"
greenf="${colorsLib_escapeChar}[32m"
yellowf="${colorsLib_escapeChar}[33m"
bluef="${colorsLib_escapeChar}[34m"
purplef="${colorsLib_escapeChar}[35m"
cyanf="${colorsLib_escapeChar}[36m"
lightGrayf="${colorsLib_escapeChar}[37m"

darkGrayf="${colorsLib_escapeChar}[1;30m"
lightRedf="${colorsLib_escapeChar}[1;31m"
lightGreenf="${colorsLib_escapeChar}[1;32m"
yellowf="${colorsLib_escapeChar}[1;33m"
lightBluef="${colorsLib_escapeChar}[1;34m"
lightPurplef="${colorsLib_escapeChar}[1;35m"
lightCyanf="${colorsLib_escapeChar}[1;36m"
whitef="${colorsLib_escapeChar}[1;37m"

blackb="${colorsLib_escapeChar}[40m"
redb="${colorsLib_escapeChar}[41m"
greenb="${colorsLib_escapeChar}[42m"
yellowb="${colorsLib_escapeChar}[43m"
blueb="${colorsLib_escapeChar}[44m"
purpleb="${colorsLib_escapeChar}[45m"
cyanb="${colorsLib_escapeChar}[46m"
whiteb="${colorsLib_escapeChar}[47m"

boldon="${colorsLib_escapeChar}[1m"
boldoff="${colorsLib_escapeChar}[22m"
italicson="${colorsLib_escapeChar}[3m"
italicsoff="${colorsLib_escapeChar}[23m"
ulon="${colorsLib_escapeChar}[4m"
uloff="${colorsLib_escapeChar}[24m"
invon="${colorsLib_escapeChar}[7m"
invoff="${colorsLib_escapeChar}[27m"

blinkOn="${colorsLib_escapeChar}[5m"
reset="${colorsLib_escapeChar}[0m"

#  _____ ____   ____    _    ____  _____    ____ ___  ____  _____ ____
# | ____/ ___| / ___|  / \  |  _ \| ____|  / ___/ _ \|  _ \| ____/ ___|
# |  _| \___ \| |     / _ \ | |_) |  _|   | |  | | | | | | |  _| \___ \
# | |___ ___) | |___ / ___ \|  __/| |___  | |__| |_| | |_| | |___ ___) |
# |_____|____/ \____/_/   \_\_|   |_____|  \____\___/|____/|_____|____/

###################################
#                                 #
#   ANSI COLOR ESCAPE SEQUENCES   #
#                                 #
###################################

# Sequence    Text Color  Sequence    Text Color

# \033[0;30m  Black       \033[1;30m  Dark Gray
# \033[0;31m  Red         \033[1;31m  Light Red
# \033[0;32m  Green       \033[1;32m  Light Green
# \033[0;33m  Brown       \033[1;33m  Yellow
# \033[0;34m  Blue        \033[1;34m  Light Blue
# \033[0;35m  Purple      \033[1;35m  Light Purple
# \033[0;36m  Cyan        \033[1;36m  Light Cyan
# \033[0;37m  Light Grey  \033[1;37m  White

# Sequence    Background Color

# \033[0;40m  Black
# \033[0;41m  Red
# \033[0;42m  Green
# \033[0;43m  Brown
# \033[0;44m  Blue
# \033[0;45m  Purple
# \033[0;46m  Cyan
# \033[0;47m  Light Grey

# COLOR_NC='\e[0m' # No Color
# COLOR_BLACK='\e[0;30m'
# COLOR_GRAY='\e[1;30m'
# COLOR_RED='\e[0;31m'
COLOR_LIGHT_RED='\e[1;31m'
# COLOR_GREEN='\e[0;32m'
# COLOR_LIGHT_GREEN='\e[1;32m'
# COLOR_BROWN='\e[0;33m'
# COLOR_YELLOW='\e[1;33m'
# COLOR_BLUE='\e[0;34m'
# COLOR_LIGHT_BLUE='\e[1;34m'
# COLOR_PURPLE='\e[0;35m'
# COLOR_LIGHT_PURPLE='\e[1;35m'
# COLOR_CYAN='\e[0;36m'
# COLOR_LIGHT_CYAN='\e[1;36m'
# COLOR_LIGHT_GRAY='\e[0;37m'
# COLOR_WHITE='\e[1;37m'
