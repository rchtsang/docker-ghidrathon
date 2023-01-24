#!/bin/bash

set -e

#----------------------------------------
# Ghidra launch
#----------------------------------------
SCRIPT_DIR=/ghidra
SCRIPT_FILE=/ghidra/ghidraRun
# Maximum heap memory may be changed if default is inadequate. This will generally be up to 1/4 of
# the physical memory available to the OS. Uncomment MAXMEM setting if non-default value is needed.
MAXMEM=${MAXMEM:-768M}
# Launch Ghidra
exec "${SCRIPT_DIR}"/support/launch.sh fg jdk Ghidra $MAXMEM "" ghidra.GhidraRun "$@"

exec "$@"