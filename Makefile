DEBUG = -g
#OFLAG = -Os
OFLAG =
# -fasm-blocks
# General flags setup
CFLAGS = $(DEBUG) $(OFLAG) -Wall -Wno-pointer-to-int-cast -fno-builtin-printf
STATIC = -static

TARGETS_ALL_ARCHS = hello-static hello-dynamic args func
TARGETS_ALL_ARCHS_64 = hello-static-64 hello-dynamic-64 args-64 func-64
SFILES = sys_exit.S sys_write.S

LIBDIRS = Csu-79

os := $(shell uname)

ifneq (,$(filter Linux NetBSD FreeBSD OpenBSD,$(os)))
# Linux/FreeBSD/NetBSD/OpenBSD
arch := $(shell uname -m)
DIRS = 
LD = gcc
ifeq (ppc,$(arch))
  ARCH32 = -mpowerpc
  ARCH64 = -mppc64
  CFLAGS_STATIC = $(CFLAGS) $(ARCH32) $(STATIC)
  CFLAGS_STATIC_64 = $(CFLAGS) $(ARCH64) $(STATIC)
  CFLAGS_DYNAMIC = $(CFLAGS) $(ARCH32)
  CFLAGS_DYNAMIC_64 = $(CFLAGS) $(ARCH64)
  LDFLAGS_STATIC = $(ARCH32) $(STATIC)
  LDFLAGS_STATIC_64 = $(ARCH64) $(STATIC)
  LDFLAGS_DYNAMIC = $(ARCH32)
  LDFLAGS_DYNAMIC_64 = $(ARCH64)
  TARGETS = ${TARGETS_ALL_ARCHS}
  TEST = test-powerpc
else
 ifneq (,$(filter armv5tejl armv7l, $(arch)))
  ARCH32 =
  ARCH64 =
  ARCHS = 
  CFLAGS_STATIC = $(CFLAGS) $(ARCH32) $(STATIC)
  CFLAGS_STATIC_64 = $(CFLAGS) $(ARCH64) $(STATIC)
  CFLAGS_DYNAMIC = $(CFLAGS) $(ARCH32)
  CFLAGS_DYNAMIC_64 = $(CFLAGS) $(ARCH64)
  LDFLAGS_STATIC = $(ARCH32) $(STATIC) $(LDFLAGS_GEN_STATIC)
  LDFLAGS_STATIC_64 = $(ARCH64) $(STATIC) $(LDFLAGS_GEN_STATIC)
  LDFLAGS_DYNAMIC = $(ARCH32) $(LDFLAGS_GEN_DYNAMIC)
  LDFLAGS_DYNAMIC_64 = $(ARCH64) $(LDFLAGS_GEN_DYNAMIC)
  TARGETS = ${TARGETS_ALL_ARCHS}
  TEST = test-arm
else
 ifneq (,$(filter i386 i486 i586 i686,$(arch)))
  ARCH32 = -march=i386
  ARCH64 = -march=x86_64
  CFLAGS_STATIC = $(CFLAGS) $(ARCH32) $(STATIC)
  CFLAGS_STATIC_64 = $(CFLAGS) $(ARCH64) $(STATIC)
  CFLAGS_DYNAMIC = $(CFLAGS) $(ARCH32)
  CFLAGS_DYNAMIC_64 = $(CFLAGS) $(ARCH64)
  LDFLAGS_STATIC = $(ARCH32) $(STATIC)
  LDFLAGS_STATIC_64 = $(ARCH64) $(STATIC)
  LDFLAGS_DYNAMIC = $(ARCH32)
  LDFLAGS_DYNAMIC_64 = $(ARCH64)
  TARGETS = ${TARGETS_ALL_ARCHS} hello-static-sysenter
  TEST = test-x86
 endif
endif
endif

else
# Darwin/OSX
arch := $(shell uname -p)
DIRS = $(LIBDIRS)
LD = ld
LDFLAGS_GEN_STATIC = -L./$(LIBDIRS) -lcrt0.o
LDFLAGS_GEN_DYNAMIC =
ifeq (powerpc,$(arch))
  ARCH32 = -arch ppc
  ARCH64 = -arch ppc64
  ARCHS = ppc ppc64
  CFLAGS_STATIC = $(CFLAGS) $(ARCH32) $(STATIC) -fno-builtin-printf
  CFLAGS_STATIC_64 = $(CFLAGS) $(ARCH64) $(STATIC) -fno-builtin-printf
  CFLAGS_DYNAMIC = $(CFLAGS) $(ARCH32)
  CFLAGS_DYNAMIC_64 = $(CFLAGS) $(ARCH64)
  LDFLAGS_STATIC = $(ARCH32) $(STATIC) $(LDFLAGS_GEN_STATIC)
  LDFLAGS_STATIC_64 = $(ARCH64) $(STATIC) $(LDFLAGS_GEN_STATIC)
  LDFLAGS_DYNAMIC = $(ARCH32) $(LDFLAGS_GEN_DYNAMIC)
  LDFLAGS_DYNAMIC_64 = $(ARCH64) $(LDFLAGS_GEN_DYNAMIC)
  TARGETS = ${TARGETS_ALL_ARCHS} ${TARGETS_ALL_ARCHS_64} hello-static-fat func_main
  TEST = test-powerpc
else
 ifneq (,$(filter arm,$(arch)))
  ARCH32 =
  ARCH64 =
  ARCHS = 
  CFLAGS_STATIC = $(CFLAGS) $(ARCH32) $(STATIC)
  CFLAGS_STATIC_64 = $(CFLAGS) $(ARCH64) $(STATIC)
  CFLAGS_DYNAMIC = $(CFLAGS) $(ARCH32)
  CFLAGS_DYNAMIC_64 = $(CFLAGS) $(ARCH64)
  LDFLAGS_STATIC = $(ARCH32) $(STATIC) $(LDFLAGS_GEN_STATIC)
  LDFLAGS_STATIC_64 = $(ARCH64) $(STATIC) $(LDFLAGS_GEN_STATIC)
  LDFLAGS_DYNAMIC = $(ARCH32) $(LDFLAGS_GEN_DYNAMIC)
  LDFLAGS_DYNAMIC_64 = $(ARCH64) $(LDFLAGS_GEN_DYNAMIC)
  TARGETS = ${TARGETS_ALL_ARCHS} func_main
  TEST = test-arm
  # We are on an iphone, we need to help the binary to be launched ;)
  LDID = /usr/bin/ldid
else
 ifneq (,$(filter i386 i486 i586 i686,$(arch)))
  ARCH32 = -arch i386
  ARCH64 = -arch x86_64
  ARCHS = i386 x86_64
  CFLAGS_STATIC = $(CFLAGS) $(ARCH32) $(STATIC)
  CFLAGS_STATIC_64 = $(CFLAGS) $(ARCH64) $(STATIC)
  CFLAGS_DYNAMIC = $(CFLAGS) $(ARCH32)
  CFLAGS_DYNAMIC_64 = $(CFLAGS) $(ARCH64)
  LDFLAGS_STATIC = $(ARCH32) $(STATIC) $(LDFLAGS_GEN_STATIC)
  LDFLAGS_STATIC_64 = $(ARCH64) $(STATIC) $(LDFLAGS_GEN_STATIC)
  LDFLAGS_DYNAMIC = $(ARCH32) $(LDFLAGS_GEN_DYNAMIC)
  LDFLAGS_DYNAMIC_64 = $(ARCH64) $(LDFLAGS_GEN_DYNAMIC)
  TARGETS = ${TARGETS_ALL_ARCHS} ${TARGETS_ALL_ARCHS_64} hello-static-sysenter hello-static-sysenter-64 func_main
  TEST = test-x86
 endif
endif
endif
endif



SRCROOT = .
SYMROOT = .
OBJROOT = .
ARCHIVEROOT = ./bin-arch
DIRS += utils

CFILES = hello.c 
OBJFILES = 
CC = gcc

# default target for development builds
all: subdirs $(ARCHIVEROOT) $(TARGETS)

# rules for static binaries
$(OBJROOT)/%.static.o : $(SRCROOT)/%.c
	$(CC) -c $(CFLAGS_STATIC) $^ -o $@
	
$(OBJROOT)/%.static.o : $(SRCROOT)/%.S
	$(CC) -c $(CFLAGS_STATIC) $^ -o $@

$(OBJROOT)/%.sysenter.static.o : $(SRCROOT)/%.S
	$(CC) -c $(CFLAGS_STATIC) -DSYSENTER $^ -o $@

$(OBJROOT)/%.static.64.o : $(SRCROOT)/%.c
	$(CC) -c $(CFLAGS_STATIC_64) $^ -o $@
	
$(OBJROOT)/%.static.64.o : $(SRCROOT)/%.S
	$(CC) -c $(CFLAGS_STATIC_64) $^ -o $@

$(OBJROOT)/%.sysenter.static.64.o : $(SRCROOT)/%.S
	$(CC) -c $(CFLAGS_STATIC_64) -DSYSENTER $^ -o $@

# rules for dynamic binaries
$(OBJROOT)/%.o : $(SRCROOT)/%.c
	$(CC) -c $(CFLAGS_DYNAMIC) $^ -o $@
	
$(OBJROOT)/%.o : $(SRCROOT)/%.S
	$(CC) -c $(CFLAGS_DYNAMIC) $^ -o $@

$(OBJROOT)/%.64.o : $(SRCROOT)/%.c
	$(CC) -c $(CFLAGS_DYNAMIC_64) $^ -o $@
	
$(OBJROOT)/%.64.o : $(SRCROOT)/%.S
	$(CC) -c $(CFLAGS_DYNAMIC_64) $^ -o $@

$(OBJROOT)/%.$(arch).dylib: $(SRCROOT)/%.c
	$(CC) -dynamiclib -Wl,-headerpad_max_install_names,-undefined,dynamic_lookup,-compatibility_version,1.0,-current_version,1.0,-install_name,@executable_path/$@ -o $@ $^
	cp $@ $(ARCHIVEROOT)


$(ARCHIVEROOT):
	mkdir $(ARCHIVEROOT)

subdirs:
	-for d in $(DIRS); do (cd $$d; $(MAKE) RC_ARCHS="$(ARCHS)" CC="$(CC)"); done


# Static targets
hello-static: hello.static.o sys_exit.static.o sys_write.static.o
	$(LD) $(LDFLAGS_STATIC) $^ -o $@
	if [ -n "$(LDID)" ]; then $(LDID) -S $@; fi
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

hello-static-sysenter: hello.static.o sys_exit.sysenter.static.o sys_write.sysenter.static.o
	$(LD) $(LDFLAGS_STATIC) $^ -o $@ 
	if [ -n "$(LDID)" ]; then $(LDID) -S $@; fi
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

hello-static-64: hello.static.64.o sys_exit.sysenter.static.64.o sys_write.sysenter.static.64.o
	$(LD) $(LDFLAGS_STATIC_64) $^ -o $@ 
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

hello-static-sysenter-64: hello.static.64.o sys_exit.sysenter.static.64.o sys_write.sysenter.static.64.o
	$(LD) $(LDFLAGS_STATIC_64) $^ -o $@ 
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

args: args.static.o printf.static.o strcmp.static.o sys_exit.static.o sys_write.static.o get_stack_pointer.static.o asm_hack_arm.static.o
	$(LD) $(LDFLAGS_STATIC) $^ -o $@
	if [ -n "$(LDID)" ]; then $(LDID) -S $@; fi
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

args-64: args.static.64.o printf.static.64.o strcmp.static.64.o sys_exit.static.64.o sys_write.static.64.o get_stack_pointer.static.64.o
	$(LD) $(LDFLAGS_STATIC_64) $^ -o $@
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

func: func.static.o sys_exit.static.o sys_write.static.o
	$(LD) $(LDFLAGS_STATIC) $^ -o $@
	if [ -n "$(LDID)" ]; then $(LDID) -S $@; fi
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

func-64: func.static.64.o sys_exit.static.64.o sys_write.static.64.o
	$(LD) $(LDFLAGS_STATIC_64) $^ -o $@
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

# Dynamic targets
# Let do the linkage by gcc
hello-dynamic: hello.o
	$(CC) $(LDFLAGS_DYNAMIC) $^ -o $@
	if [ -n "$(LDID)" ]; then $(LDID) -S $@; fi
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

hello-dynamic-64: hello.64.o
	$(CC) $(LDFLAGS_DYNAMIC_64) $^ -o $@ 
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

func_main: func_main.o libfunc.$(arch).dylib
	$(CC) $^ -o func_main
	if [ -n "$(LDID)" ]; then $(LDID) -S $@; fi
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)


.IGNORE: hello-static-fat

hello-static-fat: $(ARCHIVEROOT)/hello-static-Darwin-i386 $(ARCHIVEROOT)/hello-static-Darwin-powerpc
	lipo -create $^ -output hello-static-fat

clean:
	rm -f $(OBJROOT)/*.s $(OBJROOT)/*.o $(OBJROOT)/*.dylib *.core $(TARGETS)
	-for d in $(DIRS); do (cd $$d; $(MAKE) clean ); done

mrproper: clean
	rm -f *~
	rm -f $(ARCHIVEROOT)/*
	-for d in $(DIRS); do (cd $$d; $(MAKE) mrproper ); done

test: $(TEST)

test-powerpc: hello-static
	@echo "====================="
	@echo "Testing hello world with SC on PPC"
	@./hello-static; echo Return: $$?
	@echo 
	@echo 
	@echo "====================="
	@echo "Testing hello world FAT file"
	@./hello-static-fat; echo Return: $$?


test-x86: hello-static hello-static-sysenter
	@echo "====================="
	@echo "Testing hello world with INT 0x80"
	@./hello-static; echo Return: $$?
	@echo 
	@echo 
	@echo "====================="
	@echo "Testing hello world with SYSENTER"
	@./hello-static-sysenter; echo Return: $$?
	@echo 
	@echo 
	@echo "====================="
	@echo "Testing hello world FAT file"
	@./hello-static-fat; echo Return: $$?
	@echo 
	@echo 
	@echo "====================="
	@echo "Testing args"
	@./args
	@echo "Testing args hello world"
	@./args hello world

test-arm: hello-static
	@echo "====================="
	@echo "Testing hello world with SWI on ARM"
	@./hello-static; echo Return: $$?
	@echo 

