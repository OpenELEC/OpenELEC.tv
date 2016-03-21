#!/bin/sh

DISK=/dev/mmcblk0
TMP=/tmp/mnt/
TMPCFG=/tmp/boot.cfg

SYSTEM_SIZE=512
STORAGE_SIZE=32 # STORAGE_SIZE must be >= 32 !

DISK_SIZE=$(( $SYSTEM_SIZE + $STORAGE_SIZE + 4 ))

echo ""
echo -e "\033[36m==============================="
echo "Installing OpenELEC to eMMC"
echo -e "===============================\033[37m"
echo ""

echo ""
echo -n "WARNING: ALL DATA ON eMMC WILL BE ERASED !, Continue (y/N)?  "
read -n 1 ANSWER

if [ ! "${ANSWER}" = "y" ] ; then
    echo "Canceled.."
    exit 0
fi
echo ""

umount ${DISK}* > /dev/null 2>&1

echo "Erasing eMMC ..."
dd if=/dev/zero of="$DISK" bs=1M count="$DISK_SIZE" conv=fsync > /dev/null 2>&1
sync

SYSTEM_PART_END=$(( $SYSTEM_SIZE * 1024 * 1024 / 512 + 2048 ))

echo "Creating partition table"
parted -s "$DISK" mklabel msdos

echo "Creating first partition"
parted -s "$DISK" -a min unit s mkpart primary fat32 2048 $SYSTEM_PART_END
parted -s "$DISK" set 1 boot on
sync

STORAGE_PART_START=$(( $SYSTEM_PART_END + 2048 ))
STORAGE_PART_END=$(( $STORAGE_PART_START + (( $STORAGE_SIZE * 1024 * 1024 / 512 )) ))

echo "Creating second partition"
parted -s "$DISK" -a min unit s mkpart primary ext4 $STORAGE_PART_START $STORAGE_PART_END
sync

partprobe -s $DISK > /dev/null 2>&1

echo "Creating filesystems"
mkfs.vfat -n EMMCBOOT ${DISK}p1 > /dev/null 2>&1
mkfs.ext4 -L emmclinux ${DISK}p2 > /dev/null 2>&1
sync

echo "Installing bootloader"
dd if=/usr/share/bootloader/u-boot-sunxi-with-spl.bin of="$DISK" bs=1k seek=8 conv=notrunc > /dev/null 2>&1

echo "Copying files on first partition"

mkdir ${TMP}

# prepare boot.cfg
dd if=/flash/boot.scr of=${TMPCFG} bs=72 skip=1 > /dev/null 2>&1
sed -i 's/mmcblk1/mmcblk0/g' ${TMPCFG}

mount -t vfat ${DISK}p1 ${TMP}
cp /flash/* ${TMP}/
mkimage -A arm \
            -O u-boot \
            -T script \
            -C none \
            -n "OpenELEC Boot" \
            -d ${TMPCFG} \
            ${TMP}/boot.scr > /dev/null 2>&1
umount ${TMP}

echo "Populating second partition"
mount -t ext4 ${DISK}p2 ${TMP}
touch ${TMP}/.please_resize_me
umount ${TMP}

echo "Done"
