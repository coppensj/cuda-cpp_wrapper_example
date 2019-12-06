#include "cuda_example.h"

void call_cuda_program (
        float *result, 
        const float *data,
        const float *params,
        const int nrows,
        const int ncols, 
        const int numparams)
{
    run_cuda_kernel(result, data, params, nrows, ncols, numparams);
}
