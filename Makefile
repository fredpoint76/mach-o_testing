DEBUG = -g
#OFLAG = -Os
OFLAG =
# -fasm-blocks
CFLAGS_STATIC = -static $(DEBUG) $(OFLAG) -Wall
CFLAGS_DYNAMIC = $(DEBUG) $(OFLAG) -Wall


TARGETS_ALL_ARCHS = hello-static hello-dynamic args
SFILES = sys_exit.S sys_write.S

LIBDIRS = Csu-75

os := $(shell uname)

ifneq (,$(filter Linux NetBSD FreeBSD,$(os)))
LDFLAGS_STATIC = -static
LDFLAGS_STATIC_64 = -static
LDFLAGS_DYNAMIC =
DIRS = 
LD = gcc
arch := $(shell uname -m)
ifeq (ppc,$(arch))
  CFLAGS_ARCH32 = -mpowerpc
  CFLAGS_ARCH64 = -mppc64
  TARGETS = ${TARGETS_ALL_ARCHS}
  TEST = test-powerpc
else
 ifneq (,$(filter i386 i486 i586 i686,$(arch)))
  CFLAGS_ARCH32 = -march=i386
  CFLAGS_ARCH64 = -march=x86_64
  TARGETS = ${TARGETS_ALL_ARCHS} hello-static-sysenter
  TEST = test-x86
 endif
endif

else
LDFLAGS_STATIC = -static -L./Csu-75 -lcrt0.o
LDFLAGS_STATIC_64 = -static -L./Csu-75 -lcrt0.o
LDFLAGS_DYNAMIC = -L./Csu-75 -lcrt1.o -lgcc_s.10.5 -lSystem
DIRS = $(LIBDIRS)
LD = ld
arch := $(shell uname -p)
ifeq (powerpc,$(arch))
  CFLAGS_ARCH32 = -arch ppc
  CFLAGS_ARCH64 = -arch ppc64
  TARGETS = ${TARGETS_ALL_ARCHS} hello-static-FAT
  TEST = test-powerpc
else
 ifneq (,$(filter i386 i486 i586 i686,$(arch)))
  CFLAGS_ARCH32 = -arch i386
  CFLAGS_ARCH64 = -arch x86_64
  TARGETS = ${TARGETS_ALL_ARCHS} hello-static-sysenter
  TEST = test-x86
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


# default target for development builds
all: subdirs $(ARCHIVEROOT) $(TARGETS) $(TEST)

# rules
$(OBJROOT)/%.o : $(SRCROOT)/%.c
	$(CC) -c $(CFLAGS_DYNAMIC) $^ -o $@
	
$(OBJROOT)/%.o : %.S
	$(CC) -c $(CFLAGS_DYNAMIC) $^ -o $@

$(OBJROOT)/%.64.o : %.c
	$(CC) -c $(CFLAGS_DYNAMIC) -m64 $^ -o $@
	
$(OBJROOT)/%.64.o : %.S
	$(CC) -c $(CFLAGS_DYNAMIC) -m64 $^ -o $@

$(OBJROOT)/%.static.o : $(SRCROOT)/%.c
	$(CC) -c $(CFLAGS_STATIC) $^ -o $@
	
$(OBJROOT)/%.static.o : %.S
	$(CC) -c $(CFLAGS_STATIC) $^ -o $@

$(OBJROOT)/%.sysenter.static.o : %.S
	$(CC) -c $(CFLAGS_STATIC) -DSYSENTER $^ -o $@

$(OBJROOT)/%.static.64.o : %.c
	$(CC) -c $(CFLAGS_STATIC) -m64 $^ -o $@
	
$(OBJROOT)/%.static.64.o : %.S
	$(CC) -c $(CFLAGS_STATIC) -m64 $^ -o $@

$(ARCHIVEROOT):
	mkdir $(ARCHIVEROOT)

subdirs:
	-for d in $(DIRS); do (cd $$d; $(MAKE)); done


# targets
hello-static: hello.static.o sys_exit.static.o sys_write.static.o
	# $(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -o $@
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

hello-static-sysenter: hello.static.o sys_exit.sysenter.static.o sys_write.sysenter.static.o
	# $(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -o $@ 
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

hello-static64: hello.static64.o sys_exit_sysenter.static64.o sys_write_sysenter.static64.o
	# $(LD) $(CFLAGS_ARCH64) $(LDFLAGS_STATIC_64) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH64) $(LDFLAGS_STATIC_64) $^ -o $@ 
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

hello-dynamic: hello.o sys_exit.o sys_write.o
	# $(LD) $(CFLAGS_ARCH32) $(LDFLAGS_DYNAMIC) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_DYNAMIC) $^ -o $@
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

.IGNORE: hello-static-fat

hello-static-fat: $(ARCHIVEROOT)/hello-static-Darwin-i386 $(ARCHIVEROOT)/hello-static-Darwin-powerpc
	lipo -create $^ -output hello-static-fat

args: args.static.o printf.static.o sys_exit.static.o sys_write.static.o get_stack_pointer.static.o
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -o $@
	cp $@ $(ARCHIVEROOT)/$@-$(os)-$(arch)

clean:
	rm -f $(OBJROOT)/*.s $(OBJROOT)/*.o *.core $(TARGETS)
	-for d in $(DIRS); do (cd $$d; $(MAKE) clean ); done

mrproper: clean
	rm -f *~
	rm -f $(ARCHIVEROOT)/*
	-for d in $(DIRS); do (cd $$d; $(MAKE) mrproper ); done

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

