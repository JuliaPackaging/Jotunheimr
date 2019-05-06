all: libcxx_string.$(dlext)

libcxx_string.$(dlext): libcxx_string.cc
	$(CXX) $(CPPFLAGS) $(CFLAGS) -fPIC $< -shared -o $@ $(LDFLAGS)

install: all
	mkdir -p $(libdir)
	cp -a libcxx_string.$(dlext) $(libdir)/libcxx_string.$(dlext)

clean:
	rm -f libcxx_string.$(dlext)
