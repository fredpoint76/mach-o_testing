DEBUG = -g
OFLAG = -Os
CFLAGS_STATIC = -static $(DEBUG) $(OFLAG) -Wall
CFLAGS_DYNAMIC = $(DEBUG) $(OFLAG) -Wall
LDFLAGS_STATIC = -static -L./Csu-75 -lcrt0.o
LDFLAGS_STATIC_64 = -static -L./Csu-75 -lcrt0.o
LDFLAGS_DYNAMIC = -L./Csu-75 -lcrt1.o -lgcc_s.10.5 -lSystem


arch := $(shell uname -p)

ifeq (powerpc,$(arch))
  CFLAGS_ARCH32 = -arch ppc
  CFLAGS_ARCH64 = -arch ppc64
  TARGETS = hello-static hello-static-fat
  SFILES = sys_exit_ppc.S sys_write_ppc.S
  TEST = test-ppc
else
 ifeq (i386,$(arch))
  CFLAGS_ARCH32 = -arch i386
  CFLAGS_ARCH64 = -arch x86_64
  TARGETS = hello-static hello-static-sysenter hello-static-fat
  SFILES = sys_exit.S sys_write.S sys_exit_sysenter.S sys_write_sysenter.S
  TEST = test
 endif
endif


SRCROOT = .
SYMROOT = .
OBJROOT = .
ARCHIVEROOT = ./bin-arch
LIBDIRS = Csu-75
DIRS = ${LIBDIRS}

LD = ld

CFILES = hello.c 
OBJFILES = 


TARGETS = hello-static hello-static-sysenter hello-static-fat hello-dynamic
SFILES = sys_exit.S sys_write.S
TEST = test


# default target for development builds
all: libcrt $(ARCHIVEROOT) $(TARGETS) $(TEST)

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

libcrt:
	@echo Compiling crt0 and crt1...
	cd $(LIBDIRS); make


# targets
hello-static: hello.static.o sys_exit.static.o sys_write.static.o
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -o $@
	cp $@ $(ARCHIVEROOT)/$@-$(arch)

hello-static-sysenter: hello.static.o sys_exit.sysenter.static.o sys_write.sysenter.static.o
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -o $@ 
	cp $@ $(ARCHIVEROOT)/$@-$(arch)

hello-static64: hello.static64.o sys_exit_sysenter.static64.o sys_write_sysenter.static64.o
	$(LD) $(CFLAGS_ARCH64) $(LDFLAGS_STATIC_64) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH64) $(LDFLAGS_STATIC_64) $^ -o $@ 
	cp $@ $(ARCHIVEROOT)/$@-$(arch)

hello-dynamic: hello.o sys_exit.o sys_write.o
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_DYNAMIC) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_DYNAMIC) $^ -o $@
	cp $@ $(ARCHIVEROOT)/$@-$(arch)

hello-static-fat: $(ARCHIVEROOT)/hello-static-i386 $(ARCHIVEROOT)/hello-static-ppc
	lipo -create $(ARCHIVEROOT)/hello-static-i386 $(ARCHIVEROOT)/hello-static-ppc -output hello-static-fat

clean:
	rm -f $(OBJROOT)/*.s $(OBJROOT)/*.o $(TARGETS)
	-for d in $(DIRS); do (cd $$d; $(MAKE) clean ); done

test-ppc: hello-static
	@echo "====================="
	@echo "Testing hello world with SC on PPC"
	@./hello-static; echo Return: $$?
	@echo -e "\n\n====================="
	@echo "Testing hello world FAT file"
	@./hello-static-fat; echo Return: $$?


test: hello-static hello-static-sysenter
	@echo "====================="
	@echo "Testing hello world with INT 0x80"
	@./hello-static; echo Return: $$?
	@echo -e "\n\n====================="
	@echo "Testing hello world with SYSENTER"
	@./hello-static-sysenter; echo Return: $$?
	@echo -e "\n\n====================="
	@echo "Testing hello world FAT file"
	@./hello-static-fat; echo Return: $$?


