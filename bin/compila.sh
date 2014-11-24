arm-none-eabi-as -o $1.o $1.s 
arm-none-eabi-ld -e 0 -Ttext=0x8000 -o $1.elf $1.o
arm-none-eabi-objcopy $1.elf -O binary kernel.img
cp kernel.img /tmp

