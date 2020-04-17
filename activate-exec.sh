#!/bin/sh
#
# (c) 2020 Yoichi Tanibayashi
#
# usage:
# $ activate-exec.sh venv_dir command_line
#
#   OR
#
# $ ln -s activate-exec.sh venv_dir.command_name
# $ venv_dir.command_name args
#
MYNAME=`basename $0`

if [ ${MYNAME} != "activate-exec.sh" ]; then
    VENV_DIR=${HOME}/${MYNAME%%.*}
    echo "VENV_DIR=${VENV_DIR}" >&2
    
    CMDNAME=${MYNAME#*.}
    echo "CMDNAME=${CMDNAME}" >&2

    CMDLINE="${CMDNAME} $*"
    echo "CMDLINE=${CMDLINE}" >&2
else
    VENV_DIR=$1
    echo "VENV_DIR=${VENV_DIR}" >&2
    shift

    CMDLINE=$*
    echo "CMDLINE=${CMDLINE}" >&2
fi

usage () {
    echo
    echo "  usage: ${MYNAME} venv_dir command_line"
    echo
}

if [ -z "${VENV_DIR}" ]; then
   usage
   exit 1
fi
if [ ! -d ${VENV_DIR} ]; then
    echo "${VENV_DIR}: no such directory" >&2
    usage
    exit 1
fi

if [ -z "${CMDLINE}" ]; then
    echo "no command line" >&2
    usage
    exit 1
fi

ACTIVATE_FILE="${VENV_DIR}/bin/activate"
if [ ! -f ${ACTIVATE_FILE} ]; then
    echo "${ACTIVATE_FILE}: no such file" >&2
    usage
    exit 1
fi
. ${VENV_DIR}/bin/activate

echo "VIRTUAL_ENV=$VIRTUAL_ENV" >&2

echo "CMDLINE=$CMDLINE" >&2
exec $CMDLINE
