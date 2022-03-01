#include <iostream>
using namespace std;

int gcd(int x, int y) {
	int common,x_com, y_com;
	for (int i = 1; i <= x & i<= y; i++) {//Has to reach both numbers x and y so we put &
		//Dont start at 0, cant divide by 0

		if ( (x % i) == 0 & (y % i) == 0) {
			//Give remainder, so 0 is looked for
			//Same for y
			common = i; //Save the number that was divided with
		}
		}	
	
	return common;
}

