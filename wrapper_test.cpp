#include <cstdlib>
#include "cuda_cpp_wrapper.h"

int main(){
    int nrows = 400;
    int ncols = 500;
    int numparams = 2;

    // Allocate host memory
	float *data = (float*)malloc(sizeof(float) * nrows * ncols);
	float *result = (float*)malloc(sizeof(float) * nrows * ncols);
	float *params = (float*)malloc(sizeof(float) * numparams);

    // Set example data (replace this with however you're creating/importing your own data/parameters)
    for (int row=0; row<nrows; row++){
        for (int col=0; col<ncols; col++){
            data[col + row * ncols] = col;
        }
    }
    params[0] = 1;
    params[1] = 2;

    // Call Kernel wrapper
    call_cuda_program(result, data, params, nrows, ncols, numparams);

    // do whatever with returned result...

    // Deallocate host memory
    free(data);
    free(result);
    free(params);

    return 0;
}
