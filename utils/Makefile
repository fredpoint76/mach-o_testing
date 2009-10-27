LDFLAGS = -I../../kernel/include
DIRS = 
LD = ld
TARGETS = brandelf

SRCROOT = .
SYMROOT = .
OBJROOT = .


CFILES = hello.c 
OBJFILES = 


# default target for development builds
all: $(TARGETS)

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

subdirs:
	-for d in $(DIRS); do (cd $$d; $(MAKE)); done


# targets
brandelf: brandelf.c
	gcc $(LDFLAGS) $^ -o $@ 

clean:
	rm -f $(OBJROOT)/*.s $(OBJROOT)/*.o *.core $(TARGETS)
	-for d in $(DIRS); do (cd $$d; $(MAKE) clean ); done

mrproper: clean
	rm -f *~


