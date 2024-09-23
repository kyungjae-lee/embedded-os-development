ARCH = armv7-a
MCPU = cortex-a8

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = ./os.ld

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S, build/%.o, $(ASM_SRCS))

os = build/os.axf
os_bin = build/os.bin

.PHONY: all clean run debug gdb

all: $(os)

clean:
	@rm - fr build

run: $(os)
	qemu-system-arm -M realview-pb-a8 -kernel $(os)

debug: $(os)
	qemu-system-arm -M realview-pb-a8 -kernel $(os) -S -gdb tcp::1234,ipv4

gdb:
	arm-none-eabi-gdb

$(os): $(ASM_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(os) $(ASM_OBJS)
	$(OC) -O binary $(os) $(os_bin)

build/%.o: boot/%.S
	mkdir -p $(shell dirname $@)
	$(AS) -march=$(ARCH) -mcpu=$(MCPU) -g -o $@ $<
