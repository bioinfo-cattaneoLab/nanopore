# Tutorial on installing Strique with Singularity 


### Introduction on Singularity basics
[Singularity](https://www.sylabs.io/docs/) is a container solution similar to [Docker](https://www.docker.com/). It was created by the need for reproducible and portable scientific workflows.

A software container allows a user to pack a software application _and all of its dependencies_ into a single package, which can be copied, moved, and shared without further overhead. Containers are also _portable_: they can be simply copied like you would do with regular files. A container is also _agnostic_ about the operating system where it is run, because everything is self-contained.

### Reference material
For a more in-depth guide, please refer to this great NIH tutorial: https://github.com/NIH-HPC/Singularity-Tutorial

### Installation 
For this tutorial we will use Singularity v3.4.2.
To install Singularity on your personal laptop in Ubuntu or CentOS, follow these instructions:

On Ubuntu, run these commands to make sure you have all the necessary packages installed.
```
$ sudo apt-get update

$ sudo apt-get -y install python build-essential debootstrap squashfs-tools libarchive-dev
```
On CentOS, these commmands should get you up to speed.
```
$ sudo yum update 

$ sudo yum groupinstall 'Development Tools'

$ sudo yum install wget epel-release

$ sudo yum install debootstrap.noarch squashfs-tools libarchive-devel
```
Next we'll download a compressed archive of the source code:
```
$ wget https://github.com/sylabs/singularity/releases/download/v3.4.2/singularity-3.4.2.tar.gz

$ tar -xf singularity-3.4.2.tar.gz
```
After that we are ready to install:
```
$ cd singularity-3.4.2

$ ./configure --prefix=/usr/local

$ make 

$ sudo make install
```
If you want support for tab completion of Singularity commands, you need to source the appropriate file and add it to the bash completion directory in /etc so that it will be sourced automatically when you start another shell.
```
$ . etc/bash_completion.d/singularity

$ sudo cp etc/bash_completion.d/singularity /etc/bash_completion.d/
```
If everything went according to plan, you now have a working installation of Singularity. Simply typing singularity will give you a summary of all the commands you can use. Typing singularity help <command> will give you more detailed information about running an individual command.

### Build a recipe  for Strique from DockerHub 
With Singularity you can write your own recipe but in this basic tutorial we use a function that 'pull' from [DockerHub](https://hub.docker.com/) a recipe of our program STRique ([DockerHub](https://hub.docker.com/r/giesselmann/strique), [GitRepository](https://github.com/giesselmann/STRique)) that we would obtain.
```
$ singularity pull docker://giesselmann/strique:latest
```
For testing that everything is OK we can type this other command that run a test script for STRique:
```
$ singularity exec strique-latest.simg python3 /app/scripts/STRique_test.py 
```

