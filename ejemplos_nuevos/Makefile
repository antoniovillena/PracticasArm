PREFIX= arm-none-eabi-

all: esbn5.img esbn5s.img inter1s.img inter1.img inter2s.img inter2.img \
   inter3s.img inter3.img inter4s.img inter4.img inter5s.img inter5.img

clean :
	rm -f tmp.elf
	rm -f *.o
	rm -f *.img

%.o : %.c const.h
	$(PREFIX)gcc -c -o $@ $<

%.img : %.o funcs.o
	$(PREFIX)ld -e 0 -Ttext=0x8000 -o tmp.elf $< funcs.o
	$(PREFIX)objcopy tmp.elf -O binary $@

funcs.o : funcs.s
	$(PREFIX)as -o $@ $<

%s.o : %.s
	$(PREFIX)as -o $@ $<

%s.img : %s.o funcs.o
	$(PREFIX)ld -e 0 -Ttext=0x8000 -o tmp.elf $< funcs.o
	$(PREFIX)objcopy tmp.elf -O binary $@
