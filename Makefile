# Top-level Makefile that orchestrates the build process
# Invokes Makefile2 in the build folder
# Makefile2 invokes Makefile.module on each module to be built
# Makefile.module compiles and links the kernel module from src/$(MODULE_NAME)/*.d

# Toolchain configuration
CROSS_COMPILE:=aarch64-linux-gnu-
DC=gdc
AS:=as

# Build environment configuration
INSTALL_DIR:=/media/$(LOGNAME)/boot
BUILD_DIRNAME:=build
SOURCE_DIRNAME:=src
PROJECT_DIR:=$(CURDIR)
BUILD_DIR:=$(CURDIR)/$(BUILD_DIRNAME)
SOURCE_DIR:=$(CURDIR)/$(SOURCE_DIRNAME)

# Toolchain flags
CFLAGS=-nostdlib -nostartfiles
LFLAGS=-nostdlib -nostartfiles

INCLUDES:=-I$(SOURCE_DIR) -I$(SOURCE_DIR)/tinyd2

# Modules to build by default
MODULES:=gpio init uart cpu tinyd

# Resolve module objects in build directory
MODULE_OBJECTS = $(MODULES:%=%.mod)

# Export variables to subdirectory make invocation
export CROSS_COMPILE
export DC

export PROJECT_DIR
export BUILD_DIR
export SOURCE_DIR

export CFLAGS
export LFLAGS
export INCLUDES

export MODULES
export MODULE_OBJECTS

# Enumerate D language source files and populate object targets
D_SOURCES:=$(shell find $(SOURCE_DIRNAME) -name "*.d")
D_OBJECTS:=$(D_SOURCES:$(SOURCE_DIRNAME)/%=%)
D_OBJECTS:=$(D_OBJECTS:%.d=%.o)
.SECONDARY: $(D_OBJECTS)
export D_OBJECTS

# Default build target: build directory and kernel image
all: $(BUILD_DIRNAME)/kernel.img

# Dump assembler output for the kernel ELF
dump: $(BUILD_DIRNAME)/kernel.img
	$(CROSS_COMPILE)objdump -d $(BUILD_DIRNAME)/kernel.img > dump

# Build kernel image
.PHONY: $(BUILD_DIRNAME)/kernel.img
$(BUILD_DIRNAME)/kernel.img: $(BUILD_DIR)
	$(info Making kernel...)
	$(MAKE) -C $(BUILD_DIR) -f $(PROJECT_DIR)/Makefile.build kernel.img

# Construct build directory tree
.PHONY: $(BUILD_DIR)
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && mkdir -p $(sort $(dir $(D_OBJECTS)))

# Remove build directory tree
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) dump

# Handy shortcut for copying the kernel image to a mounted SD card named "boot"
.PHONY: install
install: $(BUILD_DIRNAME)/kernel.img
	cp $(BUILD_DIR)/kernel.img $(INSTALL_DIR)/kernel8.img
