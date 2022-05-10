#!/bin/bash

source $AEROSTACK2_STACK/scripts/bash_utils/argparser.bash
arg_parse $@

pkg=${POS_ARGS[0]}
route=$(${AEROSTACK2_STACK}/scripts/bash_utils/as2_core_function.bash list -v --list-format | sed -e 's/ /\n/g' | grep -m 1 $pkg -A1 | tail -n 1)

if [ -z "$route" ]; then
  echo "package $pkg not found" >&2
else 
  cd $route
fi

unset route pkg CMD OPT_ARGS SHORT_OPTS LONG_OPTS POS_ARGS ALL_ARGS # clean up 

