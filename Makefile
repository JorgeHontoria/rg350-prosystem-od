CHAINPREFIX=/opt/mipsel-linux-uclibc
CROSS_COMPILE=$(CHAINPREFIX)/usr/bin/mipsel-linux-

CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
LD = $(CROSS_COMPILE)gcc

SYSROOT     := $(CHAINPREFIX)/usr/mipsel-buildroot-linux-uclibc/sysroot
SDL_CFLAGS  := $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LIBS    := $(shell $(SYSROOT)/usr/bin/sdl-config --libs)

TARGET     = rg350-prosystem-od/rg350-prosystem-od.dge

# change compilation / linking flag options
F_OPTS = -falign-functions -falign-loops -falign-labels -falign-jumps \
	-ffast-math -fsingle-precision-constant -funsafe-math-optimizations \
	-fomit-frame-pointer -fno-builtin -fno-common \
	-fstrict-aliasing  -fexpensive-optimizations \
	-finline -finline-functions -fpeel-loops
CC_OPTS	= -O2 -mips32 -mhard-float -G0 -D_OPENDINGUX_ $(F_OPTS)
CFLAGS      = $(SDL_CFLAGS) -DOPENDINGUX $(CC_OPTS)
LDFLAGS     = $(SDL_CFLAGS) $(CC_OPTS) -lSDL 

# Files to be compiled
SRCDIR  = ./emu/zlib ./emu ./opendingux
VPATH   = $(SRCDIR)
SRC_C   = $(foreach dir, $(SRCDIR), $(wildcard $(dir)/*.c))
OBJ_C   = $(notdir $(patsubst %.c, %.o, $(SRC_C)))
OBJS    = $(OBJ_C)

# Rules to make executable
$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $(TARGET) $^

$(OBJ_C) : %.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

ipk: $(TARGET)
	@rm -rf /tmp/.rg350-prosystem-od-ipk/ && mkdir -p /tmp/.rg350-prosystem-od-ipk/root/home/retrofw/emus/rg350-prosystem-od /tmp/.rg350-prosystem-od-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators /tmp/.rg350-prosystem-od-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators.systems
	@cp -r rg350-prosystem-od/rg350-prosystem-od.dge rg350-prosystem-od/rg350-prosystem-od.png rg350-prosystem-od/7800.rom /tmp/.rg350-prosystem-od-ipk/root/home/retrofw/emus/rg350-prosystem-od
	@cp rg350-prosystem-od/rg350-prosystem-od.lnk /tmp/.rg350-prosystem-od-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators
	@cp rg350-prosystem-od/atari7800.rg350-prosystem-od.lnk /tmp/.rg350-prosystem-od-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators.systems
	@sed "s/^Version:.*/Version: $$(date +%Y%m%d)/" rg350-prosystem-od/control > /tmp/.rg350-prosystem-od-ipk/control
	@cp rg350-prosystem-od/conffiles /tmp/.rg350-prosystem-od-ipk/
	@tar --owner=0 --group=0 -czvf /tmp/.rg350-prosystem-od-ipk/control.tar.gz -C /tmp/.rg350-prosystem-od-ipk/ control conffiles
	@tar --owner=0 --group=0 -czvf /tmp/.rg350-prosystem-od-ipk/data.tar.gz -C /tmp/.rg350-prosystem-od-ipk/root/ .
	@echo 2.0 > /tmp/.rg350-prosystem-od-ipk/debian-binary
	@ar r rg350-prosystem-od/rg350-prosystem-od.ipk /tmp/.rg350-prosystem-od-ipk/control.tar.gz /tmp/.rg350-prosystem-od-ipk/data.tar.gz /tmp/.rg350-prosystem-od-ipk/debian-binary

clean:
	rm -f $(TARGET) *.o
