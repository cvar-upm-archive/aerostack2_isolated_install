#!/bin/bash

usage() {
    echo "usage: as2 clean [-h]

AS2 clean workspace

optional arguments:
  -h, --help  show this help message and exit" 1>&2; exit 1;
}

positional_args=()

while [[ $# -gt 0 ]]; do case $1 in
    -h | --help )
        usage
        exit 1
        ;;
    -* | --* )
        usage
        exit 1
        ;;
    * )
        pkg=$1
        positional_args+=("$1")
        shift
        ;;
esac; done

set -- "${positional_args[@]}" # restore positional parameters

cd ${AEROSTACK2_WORKSPACE} && rm -rf build/$pkg install/$pkg log/
