all: hello_fortran$(exeext) libhello_fortran.$(dlext)

libhello_fortran.$(dlext): libhello.f
	$(FC) $(FPPFLAGS) $(FFLAGS) $< -shared -o $@ $(LDFLAGS)

hello_fortran$(exeext): hello.f
	$(FC) $(FPPFLAGS) $(FFLAGS) $< -o $@ $(LDFLAGS)

install: all
	mkdir -p $(libdir) $(prefix)/bin
	cp -a libhello_fortran.$(dlext) $(libdir)/libhello_fortran.$(dlext)
	cp -a hello_fortran$(exeext) $(prefix)/bin/hello_fortran$(exeext)

clean:
	rm -f libhello_fortran.$(dlext) hello_fortran$(exeext)

