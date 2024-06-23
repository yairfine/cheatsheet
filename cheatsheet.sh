#!/bin/bash
###
#title                  :cheatsheet.sh
#description            :This script is a cheatsheet for e.g. git or docker commands or whatever.
#author                 :Michael Wellner (@m1well) twitter.m1well.de
#date of creation       :2017-08-24
#date of last change    :2024-05-18
#version                :3.0.0
#usage                  :cheatsheet.sh [-a|-l|-g|-e|-r|-b|-i|-h|-v]
#notes                  :it would be most suitable to create an alias
###

set -eu

### colors and linebreak ###
BR="\n"
FONT_CYAN="\033[0;96m"
FONT_GREEN="\033[0;92m"
FONT_YELLOW="\033[0;93m"
FONT_NONE="\033[0m"
BACKGROUND_RED="\033[41m"
BACKGROUND_DEFAULT="\033[49m"

### output lines ###
line="//-----------------------------//"
cheatsheet="//-------- cheatsheet  --------//"
usageLine="//--- "
usageDescription="//--- Store your commands to a cheatsheet and find & execute them easily"
usageReadme="//--- Please checkout the README.md file!"
usageSum="//--- Usage: cheatsheet.sh [-a|-g|-l|-e|-r|-b|-i|-h|-v]"
usageL="//---    -l                      list all commands"
usageG="//---    -g grep [param]         grep commands including this string"
usageA="//---    -a add [param]          add a new command (you can also append a comment after a # sign)"
usageE="//---    -e execute [param]      execute a command by linenumber - it's possible to add another parameter with apostrophes after a comma"
usageR="//---    -r remove [param]       remove a command by linenumber"
usageB="//---    -b backup [param]       backup your cheatsheet to a given directory"
usageI="//---    -i import [param]       import from a cheatsheet backup from a given directory"
usageH="//---    -h help                 show help"
usageV="//---    -v version              show version"
hint1="//--- Hint:"
hint2="//--- Actually backslashes in commands are not allowed!! (due to bad display of them)"
hint3="//--- Don't use a '-' at first character to search a command! (becaus grep think it is a new option) and to add a command"
hint4="//--- For a better usage it would be most suitable to create an alias like \"alias cheat=\"[path-to-script]/cheatsheet.sh\"\""
hint5="//--- so that you can run the tool like this: \"$ cheat -l all\""
successListAll="list of all commands (with line number)"
successListGrep="list of greped commands (with line number)"
successAdd="successfully added following command to the cheatsheet"
successRemoveOne="successfully removed following command from the cheatsheet"
successRemoveAll="successfully removed all commands of the cheatsheet"
successBackup="successfully created backup of the cheatsheet"
successImport="successfully imported following amount of commands from the cheatsheet backup"
successExecute="now executing following command (possible output below cheatsheet endline)"
errorNoFile="error - no cheatsheet file available -> you have to add a first command to create the file"
errorNoDir="error - directory not exists, please provide a valid directory"
errorNoMode="error - no mode set"
errorAdd="error - this command exists already in the cheatsheet"
errorRemove="error - this line is not available - cheatsheet has only "
version1="version:                 3.0.0"
version2="date of last change:     20240518"
version3="author:                  Michael Wellner (@m1well)"

### file ###
cheatsheetFile=~/.cheatsheet

printStartLinesOfCheatsheet() {
  printf "${FONT_CYAN}"
  printf "${line}${BR}"
  printf "${cheatsheet}${BR}"
  printf "${FONT_NONE}"
}
printUsage() {
  printf "${FONT_CYAN}"
  printf "${usageLine}${BR}"
  printf "${usageDescription}${BR}"
  printf "${usageReadme}${BR}"
  printf "${usageLine}${BR}"
  printf "${usageSum}${BR}"
  printf "${usageL}${BR}"
  printf "${usageG}${BR}"
  printf "${usageA}${BR}"
  printf "${usageR}${BR}"
  printf "${usageE}${BR}"
  printf "${usageB}${BR}"
  printf "${usageI}${BR}"
  printf "${usageLine}${BR}"
  printf "${hint1}${BR}${hint2}${BR}${hint3}${BR}${hint4}${BR}${hint5}${BR}"
  printf "${usageLine}${BR}"
  printf "${FONT_NONE}"
}
printVersionInfo() {
  printf "${FONT_CYAN}"
  printf "${version1}${BR}"
  printf "${version2}${BR}"
  printf "${version3}${BR}"
  printf "${FONT_NONE}"
}
printSuccess() {
  case ${1} in
    "add")
      printf "${FONT_GREEN}${successAdd}${BR}${FONT_NONE}"
      echo "${2}"
      ;;
    "list_all")
      printf "${FONT_GREEN}${successListAll}${BR}${FONT_NONE}"
      ;;
    "list_grep")
      printf "${FONT_GREEN}${successListGrep}${BR}${FONT_NONE}"
      ;;
    "execute1")
      printf "${FONT_GREEN}${successExecute}${BR}${FONT_NONE}"
      echo "$ ${2}"
      ;;
    "execute2")
      printSuccessOfExection "${2}" "${3}"
      ;;
    "remove_all")
      printf "${FONT_GREEN}${successRemoveAll}${BR}${FONT_NONE}"
      ;;
    "remove_one")
      printf "${FONT_GREEN}${successRemoveOne}${BR}${FONT_NONE}"
      echo "${2}"
      ;;
    "backup")
      printf "${FONT_GREEN}${successBackup}${BR}${FONT_NONE}"
      ;;
    "import")
      printf "${FONT_GREEN}${successImport}${BR}${FONT_NONE}"
      echo "${2}"
      ;;
  esac
}
printSuccessOfExection() {
  printf "${FONT_GREEN}${successExecute}${BR}${FONT_NONE}"
  local escaped=$(echo "${2}" | sed 's/\//\\\//g')
  echo "$ ${1}" | sed -e "s/{1}/${escaped}/g"
}
printError() {
  case $1 in
    "file_no_file")
      printf "${BACKGROUND_RED}${errorNoFile}${BACKGROUND_DEFAULT}${BR}"
      ;;
    "directory_not_exists")
      printf "${BACKGROUND_RED}${errorNoDir}${BACKGROUND_DEFAULT}${BR}"
      ;;
    "mode")
      printf "${BACKGROUND_RED}${errorNoMode}${BACKGROUND_DEFAULT}${BR}"
      ;;
    "add")
      printf "${BACKGROUND_RED}${errorAdd}${BACKGROUND_DEFAULT}${BR}"
      ;;
    "remove")
      printf "${BACKGROUND_RED}${errorRemove}${2} lines${BACKGROUND_DEFAULT}${BR}"
      ;;
  esac
}
exitScript() {
  printf "${FONT_CYAN}${line}${FONT_NONE}${BR}"
  exit 0
}

### logical functions ###
isFileExisting() {
  if [ -e "${cheatsheetFile}" ] ; then return 0 ; fi
  return 1
}
isDirectoryExists() {
  if [ -d "${1}" ] ; then return 0 ; fi
  return 1
}
isStringEqual() {
  if [ "${1}" == "${2}" ] ; then return 0 ; fi
  return 1
}
isStringInFile() {
  if grep -Fx -q "${1}" "${2}" ; then return 0 ; fi
  return 1
}
addOneCommand() {
  # add it to the file
  echo "${1}" >> "${2}"
  # sort file instantly
  cat "${2}" | sort > "${2}".tmp
  cat "${2}".tmp >"${2}"
  rm "${2}".tmp
}
removeOneCommand() {
  # move all other commands to a tmp file
  sed "${1}d" "${2}" > ${2}.tmp
  if [[ -s "${2}".tmp ]] ; then
    # change tempfile to new cheatsheet file
    cat "${2}".tmp >"${2}"
  fi
  rm "${2}".tmp
}
printGreppedList() {
  local number=""
  local command=""
  # grep complete list and itereate over this list
  grep --line-number --ignore-case "${1}" "${2}" | while read -r greppedList ; do
    for ln in "${greppedList}" ; do
      # split the line to number and command
      number=$(echo ${ln} | cut -d ':' -f1)
      command=$(echo ${ln} | cut -d ':' -f2-)
      printf '%02u: %s\n' $number "${command}"
    done
  done
}
printCompleteList() {
  local counter=0
  while read -r completeList ; do
    for completeLine in "${completeList}" ; do
      counter=$((counter+1))
      printf '%02u: %s\n' $counter "${completeLine}"
    done
  done < "${1}"
}
executeOneCommand() {
  printf "${FONT_CYAN}${line}${BR}${FONT_NONE}"
  eval "${1}"
  exit 0
}
executeTwoCommands() {
  printf "${FONT_CYAN}${line}${BR}${FONT_NONE}"
  local escaped=$(echo "${2}" | sed 's/\//\\\//g')
  local cmd=$(echo "${1}" | sed -e "s/{1}/${escaped}/g")
  eval "${cmd}"
  exit 0
}

### start of script ###
printStartLinesOfCheatsheet

### check input opts ###
# [-a|-l|-g|-e|-r|-b|-i|-h|-v]
while getopts "a:g:e:r:b:i:lhv" arg ; do
  case $arg in
    a)
      if isFileExisting ; then
        if isStringInFile "${OPTARG}" "${cheatsheetFile}" ; then
          printError "add"
        else
          addOneCommand "${OPTARG}" "${cheatsheetFile}"
          printSuccess "add" "${OPTARG}"
        fi
      else
        # no file available
        addOneCommand "${OPTARG}" "${cheatsheetFile}"
        printSuccess "add" "${OPTARG}"
      fi
      exitScript
      ;;
    l)
      if isFileExisting ; then
        printSuccess "list_all"
        printCompleteList "${cheatsheetFile}"
      else
        # no file available
        printError "file_no_file"
        printUsage
      fi
      exitScript
      ;;
    g)
      if isFileExisting ; then
        printSuccess "list_grep"
        printGreppedList "${OPTARG}" "${cheatsheetFile}"
      else
        # no file available
        printError "file_no_file"
        printUsage
      fi
      exitScript
      ;;
    e)
      # check if there is another command after the linenumber
      if echo "${OPTARG}" | grep -q "," ; then
        paramExecute1=$(echo ${OPTARG} | cut -d ',' -f 1)
        paramExecute2="${OPTARG:${#paramExecute1}+1:${#OPTARG}-1}"
      else
        paramExecute1="${OPTARG}"
        paramExecute2="null"
      fi
      if isFileExisting ; then
        exec1=$(sed -n "${paramExecute1}"p "${cheatsheetFile}")
        if !(isStringEqual "${paramExecute2}" "null") ; then
          exec2=${paramExecute2}
          printSuccess "execute2" "${exec1}" "${exec2}"
          executeTwoCommands "${exec1}" "${exec2}"
        else
          printSuccess "execute1" "${exec1}"
          executeOneCommand "${exec1}"
        fi
      else
        # no file available
        printError "file_no_file"
        printUsage
        exitScript
      fi
      exitScript
      ;;
    r)
      if isFileExisting ; then
        countedLines=$(sed -n '$=' "${cheatsheetFile}")
        if (( "${OPTARG}" <= ${countedLines} )) ; then
          printSuccess "remove_one" "$(sed -n "${OPTARG}"p "${cheatsheetFile}")"
          removeOneCommand "${OPTARG}" "${cheatsheetFile}"
        else
          printError "remove" "${countedLines}"
        fi
      else
        # no file available
        printError "file_no_file"
        printUsage
      fi
      exitScript
      ;;
    b)
      if (isDirectoryExists "${OPTARG}") ; then
        cp "${cheatsheetFile}" "${OPTARG}"
        printSuccess "backup"
      else
        printError "directory_not_exists"
      fi
      exitScript
      ;;
    i)
      i=0
      while read -r importFileLine ; do
        if isFileExisting ; then
          if !(isStringInFile "${importFileLine}" "${cheatsheetFile}") ; then
            # if command is not in the file then import it
            addOneCommand "${importFileLine}" "${cheatsheetFile}"
            i=$((i+1))
          fi
        else
          # if file is not existing then import the command
          addOneCommand "${importFileLine}" "${cheatsheetFile}"
          i=$((i+1))
        fi
      done < "${OPTARG}/.cheatsheet"
      printSuccess "import" "${i}"
      exitScript
      ;;
    v)
      printStartLinesOfCheatsheet
      printVersionInfo
      exitScript
      ;;
    h | *)
      printStartLinesOfCheatsheet
      printUsage
      exitScript
      ;;
  esac
done
shift $((OPTIND -1))

### end of script ###
#####################
