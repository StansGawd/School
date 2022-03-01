#include <iostream>
using namespace std;

int triangular(int num) {
	int total = 1, j = 1;
	for (int i = 1; i < num; i++) {
		j++; //Adds 1 to whats being added
		total = total + j;
	}
	return total;
}


