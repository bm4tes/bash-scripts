#/bin/bash

strings_dependencies="
fold
shuf
tr
"

strings_shuffle() {
    local inputString=${1}
    echo "${inputString}"\
        | fold -w1 \
        | shuf \
        | tr -d '\n'
}

# Function to count umlauts in a string
count_umlauts() {
  local string="$1"
  local count=0

  while [[ "$string" ]]; do
    if [[ "$string" =~ [äöüÄÖÜß] ]]; then
      ((count++))
      string="${string#*[äöüÄÖÜß]}" #Remove the first umlaut and preceding characters
    else
      break # No more umlauts
    fi
  done

  echo "$count"
}
