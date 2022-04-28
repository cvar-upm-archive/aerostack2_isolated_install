#!/bin/bash
#Colours
declare greenColour="\e[0;32m\033[1m"
declare endColour="\033[0m\e[0m"
declare redColour="\e[0;31m\033[1m"
declare blueColour="\e[0;34m\033[1m"
declare yellowColour="\e[0;33m\033[1m"
declare purpleColour="\e[0;35m\033[1m"
declare turquoiseColour="\e[0;36m\033[1m"
declare grayColour="\e[0;37m\033[1m"
trap ctrl_c INT
function ctrl_c(){
    echo -e "\n\n${yellowColour}[*]${endColour}${grayColour} Exiting...\n${endColour}"
  exit 1
}
function check_init(){
  # echo -e "\n${yellowColour}[*]${endColour}${grayColour} Checking internet connection...\n${endColour}"
  if [ -z "$AEROSTACK2_STACK" ]; then
    echo -e "\n${redColour}[!]${endColour}${grayColour} AEROSTACK2_STACK variable is not set.\n${endColour}"
    exit 1
  fi
}
export package_list=();
export verbose=0;
function list_packages(){
  packages_cmakelist=$(find $AEROSTACK2_STACK -name "CMakeLists.txt"| sed -e 's/\/CMakeLists.txt//g' | sort -u)
  for package in $packages_cmakelist; do
    add_package=1
    # check if packages_cmakelist path includes a package.xml file and doesnt have a COLCON_IGNORE file in any of its parents folders
    if [ -f $package/package.xml ]; then
      path=$package
      # while path is not root
      while [ "$path" != "/" ]; do
        # check if COLCON_IGNORE file exists in path
        if [ -f $path/COLCON_IGNORE ]; then
          add_package=0
          break
        fi
        path=$(dirname $path)
      done
      if [ $add_package -eq 1 ]; then
        if grep -q "ament" $package/package.xml; then
          project_name=$(grep "<name>" $package/package.xml | sed -e 's/<name>//g' | sed -e 's/<\/name>//g' | tr -d '\n'| tr -d ' '| tr -d '\t' | tr -d '\r')
          package_list+=($project_name%%%$package)
        fi
      fi
    fi
  done
  #sort package_list by the first element separated by %%%
  package_list=($(printf '%s\n' "${package_list[@]}"|sort))
  echo -e "\n${yellowColour}[*]${endColour}${grayColour} List of packages:\n${endColour}"
  for i in "${!package_list[@]}"; do
    name=${package_list[$i]%%%*}
    path=${package_list[$i]##*%}
    if [ $verbose -eq 0 ]; then
      echo -e "${greenColour}[i]${endColour}${grayColour} ${name}${endColour}"
    else
      echo -e "${greenColour}[i]${endColour}${grayColour} ${name}${endColour} -> ${path}"
    fi
  done
}
function helpPanel(){
  echo -e "\nUtil for installing Aerostack2 projects from github\n"
  echo -e "\t${redColour}[-l]${endColour}  List available projects"
  echo -e "\t${redColour}[-h]${endColour}  Show this help"
  echo -e "\t${redColour}[-i]${endColour}  Install projects by id"
  echo -e "\t${redColour}[-n]${endColour}  Install projects by name"
  echo ""
  exit 0
}
check_init
mode="help"
args=()
# echo "Number of arguments: $#"
echo "Arguments list: $*"
# echo "'$0': $0"
# echo "'$1': $1"
#filter arguments without -
for arg in "$@"; do
  if [[ ! $arg == -* ]]; then
    args+=($arg)
  fi
done
 # -l "name:,version::,verbose" -a -o "n:v::V"
parameter_enable=0
plain=0
while getopts "i:pvh" arg; do
        case $arg in
      # l) mode="list" ;;
      # i) mode="info" && args+=($OPTARG);;
      p) plain=1 ;;
      v) verbose=1;;
            h) mode="help" && let parameter_enable+=1;;
      ?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
        esac
    done
#check first argument if its "list"
if [ $parameter_enable -eq 0 ]; then
  if [[ ${args[0]} == "list" ]]; then
    mode="list"
  elif [[ ${args[0]} == "help" ]]; then
    mode="help"
  fi
fi
 
# if plain then substitute all colors with empty string
if [ $plain -eq 1 ]; then
  greenColour=""
  endColour=""
  redColour=""
  blueColour=""
  yellowColour=""
  purpleColour=""
  turquoiseColour=""
  grayColour=""
fi
# if [ $parameter_enable -eq 0 ]; then
#   echo -e "\n${redColour}[*]${endColour}${grayColour} No parameter specified${endColour}"
#   helpPanel
# fi
if [ $mode == "list" ]; then
  list_packages
elif [ $mode == "info" ]; then
  echo "not implemented yet"
elif [ $mode == "help" ]; then
  helpPanel
fi