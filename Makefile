DEBUG = -g
OFLAG = -Os
CFLAGS_STATIC = -static $(DEBUG) $(OFLAG) -Wall
CFLAGS_DYNAMIC = $(DEBUG) $(OFLAG) -Wall
CFLAGS_ARCH32 = -arch i386
CFLAGS_ARCH64 = -arch x86_64
LDFLAGS_STATIC = -static -macosx_version_min 10.5.4 -L../Csu-75 -lcrt0.o
LDFLAGS_STATIC_64 = -static -macosx_version_min 10.5.4 -L../Csu-75_OK_64 -lcrt0.o
LDFLAGS_DYNAMIC = -macosx_version_min 10.5.4

SRCROOT = .
SYMROOT = .
OBJROOT = .
ARCHIVEROOT = ./bin-arch

TARGETS = hello-static hello-static-sysenter hello-static-fat
LD = ld

CFILES = hello.c 

arch = `uname -m`
ifeq (ppc,$(arch))
  SFILES = sys_exit_ppc.S sys_write_ppc.S
elif (i386,$(arch)) 
  SFILES = sys_exit.S sys_write.S sys_exit_sysenter.S sys_write_sysenter.S
endif


# default target for development builds
all: $(ARCHIVEROOT) $(TARGETS) test

# rules
$(OBJROOT)/%.o : $(SRCROOT)/%.c
	$(CC) -c $(CFLAGS_STATIC) $^ -o $@
	
$(OBJROOT)/%.o : %.S
	$(CC) -c $(CFLAGSi_STATIC) $^ -o $@


$(OBJROOT)/%.64.o : %.c
	$(CC) -c $(CFLAGS_DYNAMIC) -m64 $^ -o $@
	
$(OBJROOT)/%.64.o : %.S
	$(CC) -c $(CFLAGS_DYNAMIC) -m64 $^ -o $@

$(ARCHIVEROOT):
	mkdir $(ARCHIVEROOT)

# targets
hello-static: hello.o sys_exit.o sys_write.o
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -o $@
	cp $@ $(ARCHIVEROOT)/$@-$(arch)

hello-static-sysenter: hello.o sys_exit_sysenter.o sys_write_sysenter.o
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH32) $(LDFLAGS_STATIC) $^ -o $@ 
	cp $@ $(ARCHIVEROOT)/$@-$(arch)

hello-static64: hello.64.o sys_exit_sysenter.64.o sys_write_sysenter.64.o
	$(LD) $(CFLAGS_ARCH64) $(LDFLAGS_STATIC_64) $^ -S -o $@.s
	$(LD) $(CFLAGS_ARCH64) $(LDFLAGS_STATIC_64) $^ -o $@ 
	cp $@ $(ARCHIVEROOT)/$@-$(arch)

hello-static-fat: $(ARCHIVEROOT)/hello-static-i386 $(ARCHIVEROOT)/hello-static-ppc
	lipo -create $(ARCHIVEROOT)/hello-static-i386 $(ARCHIVEROOT)/hello-static-ppc -output hello-static-fat

clean:
	rm -f $(OBJROOT)/*.s $(OBJROOT)/*.o $(TARGETS)

test: hello-static
	@echo "====================="
	@echo "Testing hello world with INT 0x80"
	@./hello-static; echo Return: $$?
	@echo "\n\n====================="
	@echo "Testing hello world with SYSENTER"
	@./hello-static-sysenter; echo Return: $$?
	@echo "\n\n====================="
	@echo "Testing hello world FAT file"
	@./hello-static-fat; echo Return: $$?
