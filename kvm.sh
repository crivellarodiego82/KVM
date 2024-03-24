sudo bash kvm.sh

#!/bin/bash

# Verifica se lo script viene eseguito con privilegi di root
if [ "$(id -u)" -ne 0 ]; then
  echo "Lo script deve essere eseguito con privilegi di root."
  exit 1
fi

# Installazione di KVM e relative dipendenze
apt update
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Abilita e avvia il servizio libvirtd
systemctl enable libvirtd
systemctl start libvirtd

# Verifica la presenza del modulo kvm
if ! lsmod | grep -q kvm; then
  echo "Il modulo kvm non è stato caricato correttamente. Assicurati che il supporto alla virtualizzazione hardware sia abilitato nel BIOS/UEFI."
  exit 1
fi

# Scarica l'immagine ISO di Windows
wget -O /tmp/windows.iso https://link.dell.com/optiplex3060

# Creazione di una macchina virtuale Linux
virt-install \
--name linux_01 \
--memory 4096 \
--vcpus 2 \
--disk size=20 \
--cdrom /tmp/linux.iso \
--os-variant ubuntu20.04 \
--network network=default \
--graphics vnc \
--noautoconsole

# Creazione di una macchina virtuale Windows
virt-install \
--name windows-01 \
--memory 4096 \
--vcpus 2 \
--disk size=40 \
--cdrom /tmp/windows.iso \
--os-type windows \
--os-variant win10 \
--network network=default \
--graphics vnc \
--noautoconsole

# Rimuovi l'immagine ISO di Windows scaricata dopo l'installazione
# rm /tmp/windows.iso

echo "Installazione completata."

