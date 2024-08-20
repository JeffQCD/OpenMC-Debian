
# Guia de compilação do OpenMC criado por Jefferson Quintão Campos Duarte

#############
# ARCHLINUX #
#############

#Passos:

# Instalando algumas dependências // Instalar o gcc caso necessário
sudo pacman -Sy cmake libpng
sudo pacman -Sy hdf5

# Compilando e instalando o OpenMC
git clone --recurse-submodules https://github.com/openmc-dev/openmc.git
cd openmc
git checkout master
mkdir build && cd build
HDF5_ROOT=/usr/share/doc/hdf5
#CXX=/usr/bin/mpicxx
cmake -DCMAKE_BUILD_TYPE=Release -DHDF5_PREFER_PARALLEL=off -DOPENMC_USE_MPI=on -DCMAKE_INSTALL_PREFIX=/opt/openmc ..
_ccores=$(nproc)
if [[ "${_ccores}" =~ ^[1-9][0-9]*$ ]]; then
    make -j ${_ccores}
else
    make
fi
sudo make install
sudo ln -s /opt/openmc/bin/openmc /usr/bin/openmc
sudo ln -sf /opt/openmc/lib/libopenmc.so /usr/bin

# Criando um ambiente de trabalho e o ativando. Além de instalar as dependências do pacote python para o openmc.
cd ..
sudo pacman -Sy python python-virtualenv 
cd ..
python -m venv openmcmpi-env
source openmcmpi-env/bin/activate
cd openmc
python -m pip install .
