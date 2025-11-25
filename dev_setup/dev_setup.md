
# Developer Installation  

## Docker   

Follows [ubuntu installation](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) and [linux post-install steps](https://docs.docker.com/engine/install/linux-postinstall/).

```bash
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

# Install the latgest Docker packages
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Check installed correctly
sudo docker run hello-world

# post-install mods for non-root permissions
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# confirm user access
docker run hello-world
```

## Developer Usage

### VM testing on BioImage

#### Pull containers  

```bash
docker pull quay.io/biocontainers/salmon:1.10.1--h7e5ed60_0
docker pull quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0
docker pull quay.io/biocontainers/multiqc:1.19--pyhdfd78af_0
```

#### Part 1

```
nextflow run nextflow-io/hello
```

```
tree
```

#### Part 2

**Note:** `.main.nf` and `.nextflow.config` runs the final pipeline. 

```bash
git clone https://github.com/Sydney-Informatics-Hub/hello-nextflow.git
cd hello-nextflow/part2  
mv .nextflow.config nextflow.config
```

Run completed pipeline (includes introspection reports etc., multi-sample and multiple cpus):  

```bash
nextflow run .main.nf --reads data/samplesheet_full.csv
```
