#include "dataloop.h"

__global__ void dataloop(float *src, float *dest) 
{
	int tid = blockIdx.x;
	dest[tid] = src[tid];
}

void process_data_with_cuda(float *host_src, float *host_dest, int N)
{
	float *d_src = NULL;
	float *d_dest = NULL;

	memset(host_dest, 0, N*sizeof(float));

	// Allocate on device
	cudaMalloc((void**)&d_src, N*sizeof(float));
	cudaMalloc((void**)&d_dest, N*sizeof(float));

	// Transfer src to device
	cudaMemcpy(d_src, host_src, N*sizeof(float), cudaMemcpyHostToDevice);

	// Launch kernel
	dataloop<<<N, 1>>>(d_src, d_dest);

	// Fetch data back
	cudaMemcpy(host_dest, d_dest, N*sizeof(float), cudaMemcpyDeviceToHost);

	// Release memory
	cudaFree(d_src);
	cudaFree(d_dest);
}