INSTALL_LOCATION:=/media/$(LOGNAME)/boot
DC:=aarch64-linux-gnu-gdc
CFLAGS=-nostdlib -nostartfiles
AS:=aarch64-linux-gnu-as
INCLUDES:=-Isrc/init/ -Isrc/

all: kernel.img

%.o: %.d
	$(DC) -o $@ $(AFLAGS) -c $<

init.o: src/init/init.d
	$(DC) $(CFLAGS) $(INCLUDES) -o init.o -c src/init/init.d
gpio_arm.o: src/gpio/gpio_arm.d
	$(DC) $(CFLAGS) $(INCLUDES) -o gpio_arm.o -c src/gpio/gpio_arm.d
uart_rpi3.o: src/uart/uart_rpi3.d
	$(DC) $(CFLAGS) $(INCLUDES) -o uart_rpi3.o -c src/uart/uart_rpi3.d
start.o: src/start.s
	aarch64-linux-gnu-as -o start.o src/start.s

out.elf: init.o gpio_arm.o uart_rpi3.o start.o kernel.ld
	aarch64-linux-gnu-ld --no-undefined init.o gpio_arm.o uart_rpi3.o start.o -Map kernel.map -o out.elf -T kernel.ld

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
