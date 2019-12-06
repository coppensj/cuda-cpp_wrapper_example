#include "cuda_example.h"

__device__ float device_function(const float *data, const int row, const int col, const int ncols){
    return data[col + row * ncols] + 1;
}

__global__ void kernel(
        float *result, 
        const float *data,
        const float *params,
        const int nrows,
        const int ncols, 
        const int numparams)
{  
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    
    if (col<0 || col>=ncols || row<0 || row>=nrows) return;
    
    result[col + row * ncols] = device_function(data, row, col, ncols);
    result[col + row * ncols] *= params[0] + params[1];
}

void run_cuda_kernel(
        float *result, 
        const float *data,
        const float *params,
        const int nrows,
        const int ncols, 
        const int numparams)
{
	float *d_result, *d_data, *d_params;

	// Allocate GPU memory
	cudaMalloc((void**)&d_result, sizeof(float) * nrows * ncols);
	cudaMalloc((void**)&d_data, sizeof(float) * nrows * ncols);
	cudaMalloc((void**)&d_params, sizeof(float) * numparams);

	// Transfer data from host to device
    cudaMemcpy(d_data, data, sizeof(float) * nrows * ncols, cudaMemcpyHostToDevice);
    cudaMemcpy(d_params, params, sizeof(float) * numparams, cudaMemcpyHostToDevice);

    // Configure threads and run kernel
	dim3 block_size(32,32);
    dim3 grid_size((int)((ncols)/32+1), (int)((nrows)/32+1));
	kernel<<<grid_size,block_size>>>(d_result, d_data, d_params, nrows, ncols, numparams);

	// Transfer data back to host memory
    cudaMemcpy(result, d_result, sizeof(float) * nrows * ncols, cudaMemcpyDeviceToHost);
	
    // Deallocate device memory
    cudaFree(d_result);
    cudaFree(d_data);
    cudaFree(d_params);
}
