#include<iostream>
#include<cmath>

using namespace std;

int main()
{
  long i, j, n;
  long P, sum;

  cout << "Please enter threshold for prime number summation:"<< endl;
  cin >> n;
  i = 0;
  sum = 0;

  for(i=2; i < n; i ++)
  {
    P = 1;
    for(j = 2; j < i; j ++)
    {
      if(i%j == 0)
      {
        P = 0;
        break;
      }
    }
    if(P == 1)
    {
      cout << i << " is prime." << endl;
      sum = sum + i;
    }
  }
  cout << sum << endl;

  return 0;
}
