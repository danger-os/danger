CROSS_COMPILE:=aarch64-linux-gnu-
DC=gdc
AS:=as

INSTALL_DIR:=/media/$(LOGNAME)/boot
BUILD_DIR:=$(CURDIR)/build
SRC_DIR:=$(CURDIR)/src

CFLAGS=-nostdlib -nostartfiles
LFLAGS=-nostdlib -nostartfiles

INCLUDES:=-I$(SRC_DIR) -I$(SRC_DIR)/tinyd

export CROSS_COMPILE
export DC

export BUILD_DIR
export SRC_DIR

export CFLAGS
export LFLAGS
export INCLUDES

MODULES:=gpio init uart
MODULE_OBJ = $(MODULES:%=$(BUILD_DIR)/%.mod)

SRCS:=$(wildcard $(MODULES:%=$(SRC_DIR)/%/*.d))
OBJS:=$(SRCS:$(SRC_DIR)%=$(BUILD_DIR)%)
OBJS:=$(OBJS:%.d=%.o)
.SECONDARY: $(OBJS)

all: build $(BUILD_DIR)/kernel.img

$(BUILD_DIR)/%.mod: MODULE_DIR=$(basename $@)
$(BUILD_DIR)/%.mod: MODULE_DEP=$(filter $(MODULE_DIR)/%,$(OBJS))
$(BUILD_DIR)/%.mod: $(MODULE_DEP)
	$(info Building module ${MODULE_DIR} comprising: ${MODULE_DEP} )
	cp -f Makefile.module $(MODULE_DIR)/Makefile
	$(MAKE) -C $(MODULE_DIR) $(MODULE_DEP)
	$(CROSS_COMPILE)$(DC) $(LFLAGS) -r -o $@ $(MODULE_DEP)

$(BUILD_DIR)/start.o: $(SRC_DIR)/start.s
	$(CROSS_COMPILE)$(AS) -o $@ $<

$(BUILD_DIR)/out.elf: $(BUILD_DIR)/start.o $(MODULE_OBJ) kernel.ld
	$(CROSS_COMPILE)ld --no-undefined -o $@ $(BUILD_DIR)/start.o $(MODULE_OBJ) -Map kernel.map -T kernel.ld

$(BUILD_DIR)/kernel.img: $(BUILD_DIR)/out.elf
	$(CROSS_COMPILE)objcopy $< -O binary $@

out.list: $(BUILD_DIR)/out.elf
	$(CROSS_COMPILE)objdump -d $(BUILD_DIR)/out.elf > out.list

build:
	mkdir $(BUILD_DIR) $(MODULES:%=$(BUILD_DIR)/%)

clean:
	rm -rf $(BUILD_DIR) \
		*.elf \
		*.list \
		*.map \

install: $(BUILD_DIR)/kernel.img
	cp $(BUILD_DIR)/kernel.img $(INSTALL_DIR)/kernel8.img
