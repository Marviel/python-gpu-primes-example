#include<iostream>
#include<cmath>

using namespace std;

int main()
{
  int i, j, n;
  int P, sum;

  printf("Please enter threshold for prime number summation\n");
  cin >> n;
  i = 0;
  sum = 0;

  for(i=0; i < n; i ++)
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
      cout << i << endl;
      sum = sum + i;
    }
  }
  cout << sum << endl;

  return 0;
}