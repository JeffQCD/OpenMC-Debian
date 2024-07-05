#!/bin/bash
# Guia de compilação do OpenMC criado por Jefferson Quintão Campos Duarte

##########
# DEBIAN #
##########

#Passos:

set -e

# Instalando dependências
sudo apt update 
sudo apt upgrade
sudo apt install --reinstall openssh-server openmpi-bin libopenmpi-dev build-essential cmake libpng-dev libhdf5-dev python3-pip python3-dev python3-requests python-is-python3 git python3-mpi4py -y

# Compilando e instalando o OpenMC
git clone --recurse-submodules https://github.com/openmc-dev/openmc.git
cd openmc
git checkout master
mkdir build && cd build
HDF5_ROOT=/usr/lib/x86_64-linux-gnu/hdf5
#CXX=/usr/bin/mpicxx
cmake -DCMAKE_BUILD_TYPE=Release -DHDF5_PREFER_PARALLEL=off -DOPENMC_USE_MPI=on -DCMAKE_INSTALL_PREFIX=/opt/openmc ..
_ccores=$(nproc)
if [[ "${_ccores}" =~ ^[1-9][0-9]*$ ]]; then
    make -j ${_ccores}
else
    make
fi
sudo make install
sudo ln -sf /opt/openmc/bin/openmc /usr/bin/openmc
sudo ln -sf /opt/openmc/lib/libopenmc.so /usr/bin

# Instalando modulo do openmc no python e suas dependencias
cd ..
python -m pipx install .
python -m pipx ensurepath