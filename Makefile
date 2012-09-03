CUDA_INSTALL_PATH := /usr/local/cuda

CUDA	:= $(CUDA_INSTALL_PATH)
SDK	:= /Developer/GPU\ Computing/C

INC	:= -I$(CUDA)/include -I$(SDK)/common/inc -I.
LIB	:= -L$(CUDA)/lib   -L$(SDK)/lib 

# Mex script installed by Matlab, you may have to modify the path
MEX = /Applications/MATLAB_R2012a.app/bin/mex

NVCCFLAGS :=  -O=4 -arch=sm_11 --ptxas-options=-v -m 64
# THIS IS FOR DEBUG !!! -g -G
# IMPORTANT: don't forget the runtime (-lcudart) !
LIBS	:= -lcudart -lcusparse -lcublas

CC = g++
CFLAGS = -Wall -c -O2 -fPIC $(INC) 
LFLAGS = -Wall 
AR = ar

all: dataloop mex

kernels:
	$(CUDA)/bin/nvcc dataloop.cu -c -o dataloop.cu.o $(INC) $(NVCCFLAGS)

main.o:        main_dataloop.cpp
	${CC} $(CFLAGS) $(INC) -o main.o main_dataloop.cpp

dataloop:	kernels main.o
	${CC} $(LFLAGS) -o demo_dataloop main.o dataloop.cu.o $(LIB) $(LIBS)

dataloop.a:	kernels
	${AR} -r libdataloop.a dataloop.cu.o

mex:	dataloop.a
	${MEX} -L. -ldataloop -v mex_dataloop.cpp -L$(CUDA)/lib $(LIBS)
	install_name_tool -add_rpath /usr/local/cuda/lib mex_dataloop.mexmaci64

clean:
	rm *.o a.out *.a *.mexmaci* *~

