ARCH = armv7-a
MCPU = cortex-a8

TARGET = rvpb

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = ./os.ld
MAP_FILE = build/os.map

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S, build/%.os, $(ASM_SRCS))

VPATH = boot \
		hal/$(TARGET) \
		lib

C_SRCS = $(notdir $(wildcard boot/*.c))
C_SRCS += $(notdir $(wildcard hal/$(TARGET)/*.c))
C_SRCS += $(notdir $(wildcard lib/*.c))
C_OBJS = $(patsubst %.c, build/%.o, $(C_SRCS))

INC_DIRS = -I include		\
		   -I hal			\
		   -I hal/$(TARGET) \
		   -I lib

CFLAGS = -c -g -std=c11

os = build/os.axf
os_bin = build/os.bin

.PHONY: all clean run debug gdb

all: $(os)

clean:
	@rm -rf build

run: $(os)
	qemu-system-arm -M realview-pb-a8 -kernel $(os) -nographic

debug: $(os)
	qemu-system-arm -M realview-pb-a8 -kernel $(os) -S -gdb tcp::1234,ipv4

gdb:
	gdb-multiarch

$(os): $(ASM_OBJS) $(C_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(os) $(ASM_OBJS) $(C_OBJS) -Map=$(MAP_FILE)
	$(OC) -O binary $(os) $(os_bin)

build/%.os: %.S
	mkdir -p $(shell dirname $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) $(INC_DIRS) $(CFLAGS) -o $@ $<

build/%.o: %.c
	mkdir -p $(shell dirname $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) $(INC_DIRS) $(CFLAGS) -o $@ $<
