FC=gfortran
FFLAGS=-g -cpp -DUSE_GEN -ffixed-line-length-255 -std=legacy
#FC=ifort
#FFLAGS=-O2 -cpp -DUSE_GEN -132  

#include ../make.inc

.SUFFIXES:
.SUFFIXES: .f .f90 .o

.f90.o:
	$(FC) -c -o $@ $*.f90 $(FFLAGS) 
.f.o:
	$(FC) -c -o $@ $*.f $(FFLAGS) 


all: TSP_PATCHED m_tsp.a

TSP_PATCHED:
	if [ ! -f TSP_PATCHED ] ; then  \
		patch -u tsp98.f <  tsp98.diff ;\
		touch TSP_PATCHED ; \
	fi 

OBJ=  tsp98.o m_gen.o m_genwy.o gen.o  genwy.o 


m_tsp.a: $(OBJ)
	ar rcs m_tsp.a $(OBJ)

obj: $(OBJ)

prog: make_gen make_wy


make_gen: make_gen.o m_gen.o
	$(FC) -o $@ make_gen.o 

make_gen.o: m_gen.o 

make_wy: make_wy.o  m_genwy.o 
	$(FC) -o $@  $^

testmain: testmain.o genwy.o gen.o  m_gen.o m_genwy.o 
	$(FC) -o $@ $^

tsp98.o: m_gen.o m_genwy.o 

clean:
	rm -f *.o *.mod *.a 
