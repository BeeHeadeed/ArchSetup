read "Path to arch main partition: " MAIN_PART_PATH
while [! -d $MAIN_PART_PATH]; then
    read "Invalid path: " MAIN_PART_PATH
fi;

read "Path to arch EFI partition: " HEAD_PART_PATH
while [! -d $HEAD_PART_PATH]; then
    read "Invalid path: " HEAD_PART_PATH
fi;

sudo mount $MAIN_PART_PATH /mnt
sudo mount $HEAD_PART_PATH /mnt/boot
sudo arch-chroot /mnt

pacman -Sy linux linux-headers
mkinitcpio -P

grub-install --target=x86_64-efi -efi-directory=/boot --bootloader-id=ArchGRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg
