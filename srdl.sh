#!/usr/bin/env bash
#####################################################################
# Script Name: srdl.sh                                              #
# Authors: Franklin Henriquez (franklin.a.henriquez@gmail.com)      #
# Date: 11 Sept 2019                                                #
# Description: Downloads images from subreddit                      #
#                                                                   #
# Version: 1.0.0                                                    #
#####################################################################

# Required binaries:
# - jq
# - getopt
# - wget

# Notes:
#
#
__version__="1.0.0"
__author__="Franklin Henriquez"
__email__="franklin.a.henriquez@gmail.com"

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

# DESC: What happens when ctrl-c is pressed
# ARGS: None
# Trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
    info "Trapped CTRL-C signal, terminating script"
    exit 2
}

# Setting up logging
exec 3>&2 # logging stream (file descriptor 3) defaults to STDERR
verbosity=3 # default to show warnings
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
inf_lvl=4
dbg_lvl=5
bash_dbg_lvl=6

notify() { log $silent_lvl "NOTE: $1"; } # Always prints
critical() { log $crt_lvl "CRITICAL: $1"; }
error() { log $err_lvl "ERROR: $1"; }
warn() { log $wrn_lvl "WARNING: $1"; }
info() { log $inf_lvl "INFO: $1"; } # "info" is already a command
debug() { log $dbg_lvl "DEBUG: $1"; }
log() {
    if [ $verbosity -ge $1 ]; then
        datestring=`date +'%Y-%m-%d %H:%M:%S'`
        # Expand escaped characters, wrap at 70 chars, indent wrapped lines
        echo -e "$datestring $2" >&3 #| fold -w70 -s | sed '2~1s/^/  /' >&3
    fi
}

# DESC: Usage help
# ARGS: None

