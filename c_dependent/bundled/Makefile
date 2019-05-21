all: deppy libdependent.$(dlext)

libdependent.$(dlext): libdependent.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -shared -o $@ $(LDFLAGS)

deppy: deppy.c libdependent.$(dlext)
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -o $@ $(LDFLAGS) -L. -ldependent

install: all
	mkdir -p $(libdir) $(prefix)/bin
	cp -a libdependent.$(dlext) $(libdir)/libdependent.$(dlext)
	cp -a deppy $(prefix)/bin/deppy$(exeext)

clean:
	rm -f libdependent.$(dlext) deppy
