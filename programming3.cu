#include <iostream>
#include <sys/time.h>
#include <ctime>
#include <fstream>
#include <cmath>
#include <cstdlib>

using namespace std;

__global__ static void Init(char* primes)
{
   primes[0] = 1;
   primes[1] = 1;
}

__global__ static void sieveEvensCUDA(char* primes, int max)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x + threadIdx.x + 4;
	if (index < max) {
		primes[index] = 1;
	}
}

__global__ static void sieveCUDA(char *primes, int max, int root)
{
  
   int index = blockIdx.x * blockDim.x + threadIdx.x + 3;

   if (index < root && primes[index] == 0)
   {	  
      for (int j = index * index; j <= max; j += index)
      {
         primes[j] = 1;
      }
   }
}

__host__ void isPrime(char* primes, int max)
{
	int blockSize = 32;
	int root = sqrt(max);
	char* d_Primes = NULL;
   
	int sizePrimes = sizeof(char) * max;
   
	cudaMalloc(&d_Primes, sizePrimes);
	cudaMemset(d_Primes, 0, sizePrimes);
   
	dim3 dimBlock(blockSize);
	dim3 dimGrid((root + dimBlock.x) / dimBlock.x);
	dim3 dimGridEven((max + dimBlock.x) / dimBlock.x);
   
	Init<<<1,1>>>(d_Primes);
	sieveEvensCUDA<<<dimGridEven, dimBlock>>>(d_Primes, max);
	sieveCUDA<<<dimGrid, dimBlock>>>(d_Primes, max, root);
   
	cudaMemcpy(primes, d_Primes, sizePrimes, cudaMemcpyDeviceToHost);
   
	cudaFree(d_Primes);
   
}

int main(){

	int num;
	struct timeval start, end;
    long mtime, seconds, useconds;
	long long sum;    
	char *primes;

	cout << "Enter max positive number to sum primes to: " << endl;
	cin >> num;
	
	primes = (char*)malloc(num);
	memset(primes, 0, num);
	
	if (num < 2) {
		cout << "Entered number less than 2, no primes to sum" << endl;;
	}
	else 
		sum = 2;
	
	gettimeofday(&start, NULL);

	isPrime(primes, num);
	
	for (int n = 3; n <= num - 1; n += 2) {
		if (primes[n] == 0){
			sum += n;
			if(num >= 1 + n*n && num < (n+1)*(n + 1)) {
				sum -= n*n;
			}
		}
	}
	
	gettimeofday(&end, NULL);

	seconds  = end.tv_sec  - start.tv_sec;
	useconds = end.tv_usec - start.tv_usec;

	mtime = ((seconds) * 1000 + useconds/1000.0);

	cout << "Sum of prime numbers under " << num << " is " << sum << endl;
	cout << "Total elapsed time: " << mtime << " milliseconds\n" << endl;
	
	free(primes);
	
	return 0;
}