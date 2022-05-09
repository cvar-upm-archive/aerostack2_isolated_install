#!/bin/bash

usage() {
    echo "usage: $0 [-h] [--ros2-only] [--ros1-only] [-y] {cd,build,clean,run} ...

Aerostack2 toolbox for ease the use of the AS2 pipeline

optional arguments:
  -h, --help            show this help message and exit
  --ros2-only           use only the ros2 packages
  --ros1-only           use only the ros1 packages
  -y, --yes             answer yes to all questions

AS2 commands:
  {cd,build,clean,run}  action to do
    cd                  change directory
    build               build help
    clean               clean workspace
    run" 1>&2; exit 1;
}

OPT_ARGS=()

while [[ "$1" =~ ^- ]]; do
    OPT_ARGS+=("${1}")
    shift
done

CMD=$1; shift

case $CMD in
    build )
        source as2_build ${OPT_ARGS[@]} $*
        ;;
    clean )
        source as2_clean ${OPT_ARGS[@]} $*
        ;;
    * )
        usage
        ;;
esac
