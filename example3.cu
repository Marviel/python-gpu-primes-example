#include <stdio.h>

__global__
void saxpy(int n, int a, int *x, int *y)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  
  //y[i] = i%n;
	y[i] = 10;

  // f (i%n != 0) {
  //   y[i] = 1;
  // }
  // else{
  //   y[i] = 0;
  // }
}

int main(void)
{
  //int N = 1<<20;
  int sum;
  int *x, *y, *d_x, *d_y;
  int P, n;

  n = 1000;

  // printf("Please enter threshold for prime number summation\n");
  // puts(n);

  x = (int*)malloc(n*sizeof(int));
  y = (int*)malloc(n*sizeof(int));

  cudaMalloc(&d_x,n*sizeof(int)); 
  cudaMalloc(&d_y,n*sizeof(int));

  for (int i = 0; i < n; i++) {
    x[i] = 1;
    y[i] = 1;
  }

  
  for(int i=0; i < n; i ++)
  {
    P = 1;
		cudaMemcpy(d_x, x,n*sizeof(int), cudaMemcpyHostToDevice);
		cudaMemcpy(d_y, y,n*sizeof(int), cudaMemcpyHostToDevice);

    // Perform SAXPY on 1M elements
    saxpy<<<n,1>>>(i, 2.0f, d_x, d_y);
    cudaMemcpy(y, d_y,n*sizeof(int), cudaMemcpyDeviceToHost);


    printf("y==============\n");
    for(int j = 2; j < i; j ++)
    {
      printf("%d, ",y[j]);
      if(y[j] == 0)
      {
        P = 0;
        break;
      }
    }
    printf("\n");
    if(P == 1)
    {
      printf("Prime: %d  ",i);
      sum = sum + i;
    }
  }
}
