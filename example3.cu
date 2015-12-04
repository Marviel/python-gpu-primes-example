#include <stdio.h>

__global__
void saxpy(int n, float a, float *x, float *y)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  
  y[i] = (float*)i%n;

  // f (i%n != 0) {
  //   y[i] = 1;
  // }
  // else{
  //   y[i] = 0;
  // }
}

int main(void)
{
  int N = 1<<20;
  float *x, *y, *d_x, *d_y;
  x = (float*)malloc(N*sizeof(float));
  y = (float*)malloc(N*sizeof(float));

  cudaMalloc(&d_x, N*sizeof(float)); 
  cudaMalloc(&d_y, N*sizeof(float));

  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  cudaMemcpy(d_x, x, N*sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_y, y, N*sizeof(float), cudaMemcpyHostToDevice);

  for(i=0; i < n; i ++)
  {
    P = 1;

    // Perform SAXPY on 1M elements
    saxpy<<<(N+255)/256, 256>>>(i, 2.0f, d_x, d_y);
    cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);

    // float maxError = 0.0f;
    // for (int i = 0; i < N; i++)
    //   printf("Max error: %fn", maxError);


    for(j = 2; j < i; j ++)
    {
      if(y[j] == 0)
      {
        P = 0;
        break;
      }
    }
    if(P == 1)
    {
      printf("Prime: %f"%(i))
      sum = sum + i;
    }
  }
  cout << sum << endl;
}