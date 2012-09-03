#include <iostream>
#include "dataloop.h"

int main(int argc, char const *argv[])
{
  if (argc < 2)
  {
    std::cerr << "Usage: " << argv[0] << " vector_size" << std::endl;
    return EXIT_FAILURE;
  }

  int const N = atoi(argv[1]);
  std::cerr << "Allocating with N = " << N << std::endl;

  float *src = new float[N];
  for (int i = 0; i < N; ++i)
    *(src + i) = i;

  float *dest = new float[N];

  std::cerr << "CUDA Calling !\n";
  process_data_with_cuda(src, dest, N);

  std::cerr << "Done ! Printing output...\n";
  
  for (int i = 0; i < N; ++i)
    std::cerr << "(" << i << ")\t@in = " << *(src+i) << "\t@out = " << *(dest+i) << std::endl;

  delete[] src;
  delete[] dest;
}
