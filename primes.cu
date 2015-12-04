int* d_C;

using namespace std;

__global__ void primo(int* C, int N, int multi)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < N) 
  {
    if(i%2==0||i%3==0||i%5==0||i%7==0)
    {
      C[i]=0;           
    }
    else
    {
      C[i]=i+N*multi;
    }
  }
}

int main()
{
  cout<<"Prime numbers \n";
  int N=1000;
  int h_C[1000];
  size_t size=N* sizeof(int);
  cudaMalloc((void**)&d_C, size);

  int threadsPerBlock = 1024;
  int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
  vector<int> lista(100000000);
  int c_z=0;

  for(int i=0;i<100000;i++)
  {
    primo<<<blocksPerGrid, threadsPerBlock>>>(d_C, N,i);    
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);         
    for(int c=0;c<N;c++)
    {   
      if(h_C[c]!=0)
      {
        lista[c+N*i-c_z]=h_C[c];
      }
      else
      {
        c_z++;
      }
    }   
  }
  lista.resize(lista.size()-c_z+1);
  return(0);
}