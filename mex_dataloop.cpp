#include <iostream>
#include <cassert>
#include "dataloop.h"
#include "mex.h"
#include "matrix.h"

int const kNDims = 2;

//---------//
// Gateway //
//---------//
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray const *prhs[])
{
  std::cerr << __FUNCTION__ << " with args:\n";
  std::cerr << "Left: " << nlhs << " | " << plhs << std::endl;
  std::cerr << "Right: " << nrhs << " | " << prhs << std::endl;

  //-------------------------------------------------------------------------
  std::cerr << "Reading input...\n";
  mxArray const *src = prhs[0];
  float *p_src = (float*)mxGetData( src );
  mwSize const *srcSize = mxGetDimensions( src );
  int N = (srcSize[0] == 1 ? srcSize[1] : srcSize[0]);

  std::cerr << "Src: " << srcSize[0] << "x" << srcSize[1] << std::endl;
  std::cerr << "N = " << N << std::endl;

  //-------------------------------------------------------------------------
  std::cerr << "Configuring output...\n";
  
  plhs[0] = mxCreateNumericArray(kNDims, srcSize, mxSINGLE_CLASS, mxREAL);
  float *p_dest = (float*)mxGetData( plhs[0] );

  //-------------------------------------------------------------------------
  std::cerr << "CUDA calling ! (Tribute to the Clash.)\n";
  
  process_data_with_cuda(p_src, p_dest, N);

  std::cerr << "Back from the war. Check your PTSD syndrom.\n";

  std::cerr << std::endl;
  for (int i = 0; i < N; ++i)
    std::cerr << "(" << i << ")\t@in = " << *(p_src+i) << "\t@out = " << *(p_dest+i) << std::endl;
}
