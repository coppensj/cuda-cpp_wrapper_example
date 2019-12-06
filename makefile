override CUDAPATH = /usr/local/cuda

CXX := g++
NVCC := nvcc -ccbin /usr/bin
LINK := g++ -fPIC

INCLUDES = \
    -I. \
	-I$(CUDAPATH)/include

override CXXFLAGS += \
	$(INCLUDES) \
    -O3 \
    -std=c++17 

NVCCFLAGS += \
	$(INCLUDES) \
    -std=c++14 

override LDFLAGS += \
    -L$(DEPPATH)/lib \
    -lz \
    -lm

LIB_CUDA := \
	-L$(CUDAPATH)/lib64 \
	-lcudart

DEPS = $(shell find . -name '*.hpp' -or -name '*.h' -or -name '*.hh')

test: wrapper_test.o cuda_example.cu.o
	$(LINK) -o $@ $^ $(LIB_CUDA) $(LDFLAGS)

%.cu.o: %.cu 
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

.PHONY: clean
clean:
	@find . -name '*.o' -exec rm {} \;
	@rm -f test
