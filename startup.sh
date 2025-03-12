#!/bin/bash

# Registrar salida del script
exec > /var/log/startup-script.log 2>&1

# Definir la ruta donde se guardarán los archivos
WORK_DIR="/opt/ml-project"
USER="mj02r9"
mkdir -p $WORK_DIR
cd $WORK_DIR

echo "Actualizando paquetes..."
sudo apt-get update -y

echo "Instalando Python y asegurando que pip está actualizado..."
sudo apt install -y python3-pip python3-dev pkg-config libffi-dev libcairo2-dev gir1.2-gtk-3.0
python3 -m pip install --upgrade pip setuptools wheel

echo "Instalando dependencias de Python..."
sudo -H python3 -m pip install --no-cache-dir -r https://raw.githubusercontent.com/jeffangel/ml2f/refs/heads/main/requirements.txt

echo "Descargando dataset..."
wget -O $WORK_DIR/train_val.zip https://raw.githubusercontent.com/jeffangel/ml2f/refs/heads/main/train_val.zip

echo "Descargando e instalando CUDA..."
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb 
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-8

echo "Instalando drivers de NVIDIA..."
sudo apt-get install -y cuda-drivers

sudo apt install unzip -y
unzip -o $WORK_DIR/train_val.zip -d $WORK_DIR

sudo chown -R $USER:$USER $WORK_DIR
sudo apt install jupyter-core -y
echo 'export PATH=/home/$USER/.local/bin:$PATH' >> /etc/profile
echo 'export PATH=/home/$USER/.local/bin:$PATH' >> ~/.bashrc
source /etc/profile
source ~/.bashrc
echo "jupyter notebook --no-browser --port=8888 --ip=0.0.0.0" > "/var/log/startup-script.log"
echo "nohup jupyter notebook --no-browser --port=8888 --ip=0.0.0.0 > jupyter.log 2>&1 &" > "/var/log/startup-script.log"

echo "completed!"
