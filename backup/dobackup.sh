#!/bin/bash
set -e

echo "Norbitor's Backup Script"
echo
if [ "$EUID" -ne 0 ] ; then
    echo "Run me as root"
    exit
fi

SOURCE_DIR="/home/norbitor/"
BACKUP_DRIVE="/run/media/norbitor/hdd500/"
CURRENT_BACKUP_DIR=$BACKUP_DRIVE"backup/current"

echo "       $(tput bold)Copying from: $(tput sgr0)$SOURCE_DIR"
echo "              $(tput bold)Drive: $(tput sgr0)$BACKUP_DRIVE"
echo "$(tput bold)Current backup path: $(tput sgr0)$CURRENT_BACKUP_DIR"
echo

echo "[1/3] Synchronising $SOURCE_DIR to $CURRENT_BACKUP_DIR..."
rsync -va --inplace $SOURCE_DIR --exclude 'VirtualBox VMs' --exclude 'Pobrane' --exclude '.cache' --delete $CURRENT_BACKUP_DIR

echo "[2/3] Creating read-only btrfs snapshot..."
btrfs subvolume snapshot -r $CURRENT_BACKUP_DIR ${BACKUP_DRIVE}backup/$(date +%Y%m%d-%H%M)

echo "[3/3] Displaying btrfs statistics after backup"
btrfs subvolume list $BACKUP_DRIVE
btrfs qgroup show $BACKUP_DRIVE

