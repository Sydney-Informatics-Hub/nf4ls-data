#!/bin/bash -eu

prep_files () {
	# Create empty directory for part 1 and mv part 2 contents
	# from the data repo
	if [[ ! -d "part2" ]]; then
		"Workshop files do not exist. Are you sure you are in the nf4ls-data directory?"
		exit 1
	
	BASEPATH=$1
	mkdir -p "${BASEPATH}/part1"
	cp -rv part2 ${BASEPATH}/part2
}
