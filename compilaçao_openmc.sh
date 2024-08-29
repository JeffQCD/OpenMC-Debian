#!/bin/bash
# Guia de compilação do OpenMC criado por Jefferson Quintão Campos Duarte

##########
# DEBIAN #
##########

#Passos:

set -e
set -x

# Instalando dependências Debian
sudo apt update
sudo apt upgrade -y
sudo apt install --reinstall openssh-server openmpi-bin libopenmpi-dev build-essential cmake libpng-dev libhdf5-dev python3-pip python3-dev python-is-python3 git -y

# Instalando dependências Arch
#sudo pacman -Syu openssh base-devel cmake libpng hdf5 fmt openmpi pugixml git fmt python python-pip

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
sudo ln -sf /opt/openmc/bin/openmc /usr/bin/
sudo ln -sf /opt/openmc/lib/libopenmc.so /usr/lib/

# Instalando modulo do openmc no python e suas dependencias
cd ../../ #Voltar 1 pasta acima de openmc
python -m venv pythonenv-openmc
source pythonenv-openmc/bin/activate
cd openmc
python -m pip install . mpi4py scipy==1.11.4
cd ..
sudo mv pythonenv-openmc /opt/
echo '''
Coloque no inicio do .bashrc do usuário
source /opt/pythonenv-openmc/bin/activate
'''
