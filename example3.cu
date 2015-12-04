#include <stdio.h>

__global__
void saxpy(int n, int a, int *x, int *y)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  
  y[i] = i%n;

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
  int sum;
  int *x, *y, *d_x, *d_y;
  int P, n;

  n = 1000;

  // printf("Please enter threshold for prime number summation\n");
  // puts(n);

  x = (int*)malloc(N*sizeof(int));
  y = (int*)malloc(N*sizeof(int));

  cudaMalloc(&d_x, N*sizeof(int)); 
  cudaMalloc(&d_y, N*sizeof(int));

  for (int i = 0; i < N; i++) {
    x[i] = 1;
    y[i] = 2;
  }

  cudaMemcpy(d_x, x, N*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_y, y, N*sizeof(int), cudaMemcpyHostToDevice);

  for(int i=0; i < n; i ++)
  {
    P = 1;

    // Perform SAXPY on 1M elements
    saxpy<<<(N+255)/256, 256>>>(i, 2.0f, d_x, d_y);
    cudaMemcpy(y, d_y, N*sizeof(int), cudaMemcpyDeviceToHost);

    // float maxError = 0.0f;
    // for (int i = 0; i < N; i++)
    //   printf("Max error: %fn", maxError);


    printf("y==============\n")
    for(int j = 2; j < i; j ++)
    {
      printf("%d, ",y[j])
      if(y[j] == 0)
      {
        P = 0;
        break;
      }
    }
    printf("\n")
    if(P == 1)
    {
      printf("Prime: %d  ",i);
      sum = sum + i;
    }
  }
  //cout << sum << endl;
}