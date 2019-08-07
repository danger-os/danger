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
BUILD_DIR:=$(CURDIR)/$(BUILD_DIRNAME)
SOURCE_DIR:=$(CURDIR)/$(SOURCE_DIRNAME)

# Toolchain flags
CFLAGS=-nostdlib -nostartfiles
LFLAGS=-nostdlib -nostartfiles

INCLUDES:=-I$(SOURCE_DIR) -I$(SOURCE_DIR)/tinyd

# Modules to build by default
MODULES:=gpio init uart cpu

# Resolve module objects in build directory
MODULE_OBJECTS = $(MODULES:%=%.mod)

# Export variables to subdirectory make invocation
export CROSS_COMPILE
export DC

export BUILD_DIR
export SOURCE_DIR

export CFLAGS
export LFLAGS
export INCLUDES

export MODULES
export MODULE_OBJECTS

# Enumerate D language source files and populate object targets
D_SOURCES:=$(wildcard $(MODULES:%=$(SOURCE_DIRNAME)/%/*.d))
D_OBJECTS:=$(D_SOURCES:$(SOURCE_DIRNAME)/%=%)
D_OBJECTS:=$(D_OBJECTS:%.d=%.o)
.SECONDARY: $(D_OBJECTS)
export D_OBJECTS

# Default build target: build directory and kernel image
all: $(BUILD_DIRNAME)/kernel.img

dump: $(BUILD_DIRNAME)/kernel.img
	$(CROSS_COMPILE)objdump -d $(BUILD_DIRNAME)/kernel.img > dump

.PHONY: $(BUILD_DIRNAME)/kernel.img
$(BUILD_DIRNAME)/kernel.img: $(BUILD_DIR)
	$(info Making kernel...)
	$(MAKE) -C $(BUILD_DIR) -f "../Makefile2" kernel.img

.PHONY: $(BUILD_DIR)
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR) $(MODULES:%=$(BUILD_DIR)/%)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) dump

.PHONY: install
install: $(BUILD_DIRNAME)/kernel.img
	cp $(BUILD_DIR)/kernel.img $(INSTALL_DIR)/kernel8.img
