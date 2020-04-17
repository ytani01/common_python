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
    CMDNAME=${MYNAME#*.}
    CMDLINE="${CMDNAME} $*"
else
    VENV_DIR=$1
    shift
    CMDLINE=$*
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
echo >&2
exec $CMDLINE
