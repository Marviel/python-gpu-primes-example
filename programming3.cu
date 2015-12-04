#include <iostream>
#include <sys/time.h>
#include <ctime>
#include <fstream>
#include <cmath>
#include <cstdlib>

using namespace std;


//Eratosthanes' sieve on odds
__global__ static void sieve(char *primes, int n, int root)
{
  
   int i = blockIdx.x * blockDim.x + threadIdx.x + 3;

   if (i < root && primes[i] == 0)
   {	  
      for (long j = i * i; j <= n; j += i)
      {
         primes[j] = 1;
      }
   }
}

//Eratosthanes' sieve on evens
__global__ static void Evens(char* P, int n)
{
	long i = blockIdx.x * blockDim.x + threadIdx.x + threadIdx.x + 4;
	if (i < n) {
		P[i] = 1;
	}
}

__global__ static void Init(char* P)
{
   P[0] = 1;
   P[1] = 1;
}

__host__ void isPrime(char* P, int max)
{
	int blockSize = 32;
	long root = sqrt(max);
	char* d_Primes = NULL;
   
	long sizePrimes = sizeof(char) * max;
   
	cudaMalloc(&d_Primes, sizePrimes);
	cudaMemset(d_Primes, 0, sizePrimes);
   
	dim3 dimBlock(blockSize);
	dim3 dimGrid((root + dimBlock.x) / dimBlock.x);
	dim3 dimGridEven((max + dimBlock.x) / dimBlock.x);
   
	Init<<<1,1>>>(d_Primes);
	Evens<<<dimGridEven, dimBlock>>>(d_Primes, max);
	sieve<<<dimGrid, dimBlock>>>(d_Primes, max, root);
   
	cudaMemcpy(P, d_Primes, sizePrimes, cudaMemcpyDeviceToHost);
   
	cudaFree(d_Primes);
   
}



int main(){
  struct timeval start, end;
  long mtime, seconds, useconds;
	char *primes;

	long long sum;    
	long long num;
	
	cout << "enter number to sum primes to: " << endl;
	cin >> num;
	
	primes = (char*)malloc(num);
	memset(primes, 0, num);
	
	if (num < 2) {
		cout << "no primes to sum!" << endl;;
		return 0;
	}
	else{ 
		sum = 2;
	}

	gettimeofday(&start, NULL);

	isPrime(primes, num);
	
	for (long n = 3; n <= num - 1; n += 2) {
		if (primes[n] == 0){ //Indicates primacy
			//cout << n << " is prime." << endl;
			sum += n;
			if(num >= 1 + n*n && num < (n+1)*(n + 1)) {
				sum -= n*n;
			}
		}
	}

	free(primes);


	gettimeofday(&end, NULL);
	seconds  = end.tv_sec  - start.tv_sec;
	useconds = end.tv_usec - start.tv_usec;
	mtime = ((seconds) * 1000 + useconds/1000.0);

	cout << "sum under " << num << " is " << sum << endl;	
	cout << "time: " << mtime << " milliseconds\n" << endl;
	
	
	return 0;
}
