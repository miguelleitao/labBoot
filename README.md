# LabBoot
Boot and Bootloader lab demo

## Install Dependencies
```
dnf install dev86
dnf install glibc-devel
dnf install glibc-devel-i686
dnf install glibc-devel-2.31-4.fc32.i686.rpm
```

## Run demos

### Boot1
```
cat boot1.s
make boot1.bin
dd if=/dev/zero of=/dev/sdc bs=1k count=1000
dd if=boot1.bin of=/dev/sdc
qemu-system-i386 -drive format=raw,file=/dev/sdc
./put_flag.sh /dev/sdc
qemu-system-i386 -drive format=raw,file=/dev/sdc
```

### Boot2
cat boot2.s
make boot2.bin
fdisk /dev/sdc
cat /proc/partitions 
qemu-system-i386 -drive format=raw,file=/dev/sdc
dd if=boot2.bin of=/dev/sdc1
./put_flag.sh /dev/sdc1
qemu-system-i386 -drive format=raw,file=/dev/sdc1
qemu-system-i386 -drive format=raw,file=/dev/sdc
dd if=mbr.bin of=/dev/sdc
qemu-system-i386 -drive format=raw,file=/dev/sdc
```

### Boot3
```
cat boot3.s
make boot3.bin
dd if=boot3.bin of=/dev/sdc1
qemu-system-i386 -drive format=raw,file=/dev/sdc
```

### Syslinux
```
mkfs.fat /dev/sdc1
df
syslinux -i /dev/sdc1
qemu-system-i386 -drive format=raw,file=/dev/sdc
```

### Boot5
```
cat boot5.c
make boot5.c32
df
mount /dev/sdc1 p1
ll p1
cp boot5.c32 p1/
cp syslinux.cfg p1/
ll p1
umount p1
qemu-system-i386 -drive format=raw,file=/dev/sdc
```

