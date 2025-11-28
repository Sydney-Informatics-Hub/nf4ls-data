#!/bin/bash -eu

source lib/prep_files.sh

# Set timezone (for logging)  
TZ=$(timedatectl show --property=Timezone --value)
if [ "$TZ" != "Australia/Sydney" ]; then
    echo "Setting timezone to Australia/Sydney"
    sudo timedatectl set-timezone Australia/Sydney
fi

# Define logger
log() {
	TIMESTAMP=$(date +%y-%m-%d\ %H:%M:%S)
    echo "[${TIMESTAMP}] $@"
}

# Check executable
check_executable() {
    if [ ! -x "$(command -v $1)" ]; then
        log "ERROR: $1 not executable"
        exit 1
    fi
}

JAVA_VERSION="21"
NXF_VERSION="24.10.0"
SINGULARITY_VERSION="4.1.1+ds2-1ubuntu0.3" # apt version

## apt
log "Updating and upgrading packages..."
sudo apt update -y && sudo apt upgrade -y

log "Installing required system utilities..."
SYSUTILS=(zip unzip tree curl)
sudo apt install -y "${SYSUTILS[@]}"

log "Checking system utilities are executable..."
for util in "${SYSUTILS[@]}"; do
    check_executable "$util"
done
check_executable tr

log "Installing open-jdk-${JAVA_VERSION}-jre..."
sudo apt install -y "openjdk-${JAVA_VERSION}-jre"

log "Verifying java install..."
check_executable "java -version"

## Nextflow
log "Installing Nextflow v${NXF_VERSION}"
curl -s "https://github.com/nextflow-io/nextflow/releases/download/v${NXF_VERSION}/nextflow" \
	-o nextflow
chmod 755 ./nextflow

# Move to $PATH
sudo mv ./nextflow /usr/local/bin

log "Verifying nextflow install..."
check_executable nextflow

## Singularity
log "Installing singularity..."
sudo apt install -y singularity-container=${SINGULARITY_VERSION}
# fix version, do not upgrad
sudo apt-mark hold singularity-container

log "Verifying singularity: $(singularity --version | grep ${SINGULARITY_VERSION})"

log "Pulling biocontainers"
# When pulling containers outside of Nextflow, the default name doesn't match
# what Nextflow expects
# [0]: Link to pull container
# [1]: Amended name for nextflow to recognise
IMAGES=(
	"quay.io/biocontainers/salmon:1.10.1--h7e5ed60_0 quay.io-biocontainers-salmon-1.10.1--h7e5ed60_0.img"
	"quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0 quay.io-biocontainers-fastqc-0.12.1--hdfd78af_0.img"
	"quay.io/biocontainers/multiqc:1.19--pyhdfd78af_0 quay.io-biocontainers-multiqc-1.19--pyhdfd78af_0.img"
)

if grep -q SINGULARITY_CACHEDIR; then
	log "SINGULARITY_CACHEDIR already exported"
else
	log "Adding SINGULARITY_CACHEDIR to .bashrc"
	echo "export SINGULARITY_CACHEDIR=${HOME}/singularity" >> ~/.bashrc
	source ~/.bashrc

# In the original workshop, we used docker and docker images.
# We have since replaced docker with singularity
# For reproducibility, pull the docker images with singularity
# by adding "docker://" 
for image in "${IMAGES[@]}"; do
	# unpack string by " "
	read -r url img <<< $image
	if [[ ! -f "${SINGULARITY_CACHEDIR}/${img}" ]]; then
		singularity pull "${SINGULARITY_CACHEDIR}/${img}" "docker://${url}"
	else
		log "Skipping ${img} (already exists)"
	fi
done

if [[ ! -d "${HOME}/part1" && ! -d "${HOME}/part2 ]]; then
	log "Preparing folder structure and files for the workshop..."
	prep_file("${HOME}")
else
	log "Files already exist"
fi

log "Installation for $USER successful!"
