all: deppy libdependent.$(dlext)

CPPFLAGS += -fPIC -std=gnu99
LDFLAGS += -L$(prefix)/lib -L$(prefix)/bin

libdependent.$(dlext): libdependent.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -shared -o $@ $(LDFLAGS) -lc_simple

deppy: deppy.c libdependent.$(dlext)
	$(CC) $(CPPFLAGS) $(CFLAGS) $< -o $@ $(LDFLAGS) -L. -ldependent

install: all
	mkdir -p $(libdir) $(prefix)/bin
	cp -a libdependent.$(dlext) $(libdir)/libdependent.$(dlext)
	cp -a deppy $(prefix)/bin/deppy$(exeext)

clean:
	rm -f libdependent.$(dlext) deppy
