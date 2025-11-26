#!/usr/bin/bash -eu

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

log "Installing default-jre"
sudo apt install default-jre

log "Verifying java install..."
check_executable "java -version"

## Nextflow
log "Installing nextflow..."
curl -s https://get.nextflow.io | bash
chmod 755 ./nextflow
sudo mv ./nextflow /usr/local/bin

log "Verifying nextflow install..."
check_executable nextflow

## Singularity
log "Installing singularity..."
sudo apt install -y singularity-container

log "Pulling biocontainers"
IMAGES=(
	"quay.io/biocontainers/salmon:1.10.1--h7e5ed60_0"
	"quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0"
	"quay.io/biocontainers/multiqc:1.19--pyhdfd78af_0"
)

export SINGULARITY_CACHEDIR=${HOME}/singularity

# In the original workshop, we used docker and docker images.
# We have since replaced docker with singularity
# For reproducibility, pull the docker images with singularity
# by adding "docker://" 
for image in "${IMAGES[@]}"; do
	if [[ ! -f "${SINGULARITY_CACHEDIR}/${image}" ]]; then
    	singularity pull "docker://${image}"
	else
		log "Skipping ${image} (already exists)"
	fi
done

log "Validating singularity containers"
for image in "${IMAGES[@]}"; do
    if ! singularity inspect "${SINGULARITY_CACHEDIR}/${image}"; then
       	log "ERROR: Failed to run $image"
    	exit 1
    fi
done

log "Installation for $USER successful!"
