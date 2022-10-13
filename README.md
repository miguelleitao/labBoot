# LabBoot
Boot and Bootloader lab demo

## Install Dependencies
```
dnf install dev86
dnf install glibc-devel
dnf install glibc-devel-i686
```

## Run demos

### Boot1
```
cat boot1.s
make boot1.bin
dd if=/dev/zero of=/dev/sdX bs=1k count=1000
dd if=boot1.bin of=/dev/sdX
qemu-system-i386 -drive format=raw,file=/dev/sdX
./put_flag.sh /dev/sdX
qemu-system-i386 -drive format=raw,file=/dev/sdX
```

### Boot2
```
cat boot2.s
make boot2.bin
fdisk /dev/sdX
cat /proc/partitions 
qemu-system-i386 -drive format=raw,file=/dev/sdX
dd if=boot2.bin of=/dev/sdX1
./put_flag.sh /dev/sdX1
qemu-system-i386 -drive format=raw,file=/dev/sdX1
qemu-system-i386 -drive format=raw,file=/dev/sdX
dd if=mbr.bin of=/dev/sdX
qemu-system-i386 -drive format=raw,file=/dev/sdX
```

### Boot3
```
cat boot3.s
make boot3.bin
dd if=boot3.bin of=/dev/sdX1
qemu-system-i386 -drive format=raw,file=/dev/sdX
```

### Syslinux
```
mkfs.fat /dev/sdX1
df
syslinux -i /dev/sdX1
qemu-system-i386 -drive format=raw,file=/dev/sdX
```

### Boot5
```
cat boot5.c
make boot5.c32
df
mount /dev/sdX1 p1
ll p1
cp boot5.c32 p1/
cp syslinux.cfg p1/
ll p1
umount p1
qemu-system-i386 -drive format=raw,file=/dev/sdX
```

