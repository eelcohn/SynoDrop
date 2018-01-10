# SynoDrop
Eggdrop package for Synology DSM

## Features

Some features of the Eggdrop packages for Synology DSM:
* Compatible with DSM 6.x
* Fully integrated with HyperBackup for backup and restores
* Fully integrated with the DSM certificate services (Eggdrop v1.8.0 and higher)
* Setup wizard for basic setup during package installation (advanced setup can be done through SSH)

Source code is published in seperate repositories called `spksrc-eggdrop1.6.21` and `spksrc-eggdrop1.8.x`.

## Where can I find the package (.spk) for my DiskStation?
Binary files can be found under [Releases](https://github.com/eelcohn/SynoTcl/releases/).

## How can I compile the package myself?
The source of these packages can be found at https://github.com/SynoCommunity/spksrc/

To create these packages I've used Fedora 25 Workstation and executed the following commands:

```
sudo dnf install glibc.i686 patch
git clone https://github.com/SynoCommunity/spksrc.git
rm -rf spksrc/cross/eggdrop/
rm -rf spksrc/spk/eggdrop/
git clone https://github.com/eelcohn/SynoDrop.git --branch v1.8.2-1-20170908
mv SynoDrop/cross/eggdrop/ spksrc/cross/
mv SynoDrop/spk/tcl/ spksrc/spk/
mv SynoDrop/local.mk spksrc/
cd spksrc/spk/eggdrop/
make all-supported
```

