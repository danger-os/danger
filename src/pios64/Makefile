INSTALL_LOCATION:=/media/$(LOGNAME)/boot
AS:=aarch64-linux-gnu-as

all: kernel.img

%.o: %.s
	$(AS) -o $@ $(AFLAGS) -c $<

out.o: src.s
	aarch64-linux-gnu-as -o out.o src.s

out.elf: out.o kernel.ld
	aarch64-linux-gnu-ld --no-undefined out.o -Map kernel.map -o out.elf -T kernel.ld

kernel.img: out.elf
	aarch64-linux-gnu-objcopy out.elf -O binary kernel.img

list: out.elf
	aarch64-linux-gnu-objdump -d out.elf > out.list

clean:
	rm -rf	kernel.img \
		*.elf \
		*.list \
		*.map \
		*.o \

install: kernel.img
	cp kernel.img $(INSTALL_LOCATION)/kernel8.img
