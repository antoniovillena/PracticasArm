all: esbn5.img esbn5s.img inter1s.img inter1.img inter2s.img inter2.img \
   inter3s.img inter3.img inter4s.img inter4.img inter5s.img inter5.img

clean :
	rm -f tmp.elf
	rm -f *.o
	rm -f *.img

%.o : %.c const.h
	gcc -c -o $@ $<

%.img : %.o funcs.o
	ld -e 0 -Ttext=0x8000 -o tmp.elf $< funcs.o
	objcopy tmp.elf -O binary $@

%s.o : %.s
	as -o $@ $<

%s.img : %s.o funcs.o
	ld -e 0 -Ttext=0x8000 -o tmp.elf $< funcs.o
	objcopy tmp.elf -O binary $@
