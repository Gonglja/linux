#!/bin/bash

## ubuntu 22.04 lts kernel 最新版本
## 0.1 Install corss-compile-toochain
# sudo apt install gcc-arm-none-eabi

## 0.2 Dep
# sudo apt install flex bison
# sudo apt-get install libssl-dev
# sudo apt install u-boot-tools 
# sudo apt-get install libgmp-dev libmpc-dev

## 0.3 issue
# fdt error
# sudo apt-get purge -y --auto-remove libfdt-dev

# 0.4 配置编译链环境
# 通过buildroot 先构建编译链，生成的编译链路径如下，在路径后面加上 /usr/bin
# 
export PATH=/home/data/os/buildroot/s5pv210_smart210/host/usr/bin:$PATH
export CROSS_COMPILE=arm-linux-
export ARCH=arm

OUT_DIR=smart210

# 0.5  清除以前编译
make  O=$OUT_DIR clean 
make  O=$OUT_DIR distclean
make  O=$OUT_DIR mrproper
mkdir -p $OUT_DIR


# 1.0 配置s5pv210默认配置，指定输出位置
make smart210_defconfig O=$OUT_DIR

# 1.1 编译 uImage
make LOADADDR=0x20004000 uImage O=$OUT_DIR -j$(nproc)

# 1.2 编译 modules 并安装至./output下
make modules O=$OUT_DIR -j$(nproc)
make INSTALL_MOD_PATH=$OUT_DIR/res O=$OUT_DIR modules_install 

# 1.3 编译 dtbs 并安装至./output下
make dtbs  O=$OUT_DIR -j$(nproc)
make INSTALL_DTBS_PATH=$OUT_DIR/res O=$OUT_DIR dtbs_install


# echo "copy to ../rootfs/"
sudo cp -vrf smart210/arch/arm/boot/uImage ../smart210/rootfs
sudo cp -vrf smart210/arch/arm/boot/dts/s5pv210-smart210.dtb ../smart210/rootfs
