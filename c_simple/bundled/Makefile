all: c_simple libc_simple.$(dlext)

libc_simple.$(dlext): libc_simple.c
	$(CC) $(CPPFLAGS) $(CFLAGS) libc_simple.c -shared -o $@ $(LDFLAGS)

c_simple: c_simple.c libc_simple.$(dlext)
	$(CC) $(CPPFLAGS) $(CFLAGS) c_simple.c -o $@ $(LDFLAGS) -L. -lc_simple

install: all
	mkdir -p $(libdir) $(prefix)/bin
	cp -a libc_simple.$(dlext) $(libdir)/libc_simple.$(dlext)
	cp -a c_simple $(prefix)/bin/c_simple$(exeext)

clean:
	rm -f libc_simple.$(dlext) c_simple
