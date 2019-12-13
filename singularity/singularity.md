# Singularity tutorial


### Introduction
[Singularity](https://www.sylabs.io/docs/) is a container solution similar to [Docker](https://www.docker.com/). It was created by the need for reproducible and portable scientific workflows.

A software container allows a user to pack a software application _and all of its dependencies_ into a single package, which can be copied, moved, and shared without further overhead. Containers are also _portable_: they can be simply copied like you would do with regular files. A container is also _agnostic_ about the operating system where it is run, because everything is self-contained.

### Reference material
For a more in-depth guide, please refer to this great NIH tutorial: https://github.com/NIH-HPC/Singularity-Tutorial

### Installation
For this tutorial we will use Singularity v3.4.2 
```
sudo apt-get update

sudo apt-get -y install python build-essential debootstrap squashfs-tools libarchive-dev
```
