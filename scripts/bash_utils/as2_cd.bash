#!/bin/bash

source $AEROSTACK2_PATH/scripts/bash_utils/argparser.bash
arg_parse $@

if [[ $TERM_EXTENSION == ".zsh" ]]; then
    pkg=${POS_ARGS[1]}
else
    pkg=${POS_ARGS[0]}
fi

if [ -z ${pkg} ]; then
    cd $AEROSTACK2_PATH
    
else
    
    route=$(${AEROSTACK2_PATH}/scripts/bash_utils/as2_core_function.bash list -v --list-format | sed -e 's/ /\n/g' | grep -E "^$pkg\$" -m 1 -A1| tail -n 1)
    
    if [ -z "$route" ]; then
        echo "package $pkg not found" >&2
    else
        cd $route
    fi
    
fi
unset route pkg CMD OPT_ARGS SHORT_OPTS LONG_OPTS POS_ARGS ALL_ARGS # clean up

