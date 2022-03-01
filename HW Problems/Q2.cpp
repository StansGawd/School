#include <iostream>
#include <string>
using namespace std;
void replace(string& s, char c1, char c2) {
	int length;
	length = s.length();
	for (int i = 0; i <= length; i++) {
		if (s[i]==c1) {
			s[i] = c2;
		}
	}
}
