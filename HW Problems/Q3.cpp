#include "string"
#include "iostream"
#include <fstream> //file stream 
using namespace std;

float calculateAverage(string classname, string filename) {
	ifstream input; //Input read stream (input)
	input.open(filename); //Reads only opens file to read
	int grade,counter1,counter2, EC_327tot, EC_440tot;
	string id, course;
	float EC_327avg, EC_440avg;

	if (input.fail()) { 
		cout << "Error! The file doesn't exist!" << endl; //Error is wrong
		return 1;
	}
	counter1 = 0;
	counter2 = 0;
	EC_327tot = 0;
	EC_440tot = 0;
	
		while (input >> id >> course >> grade) {//One line at time until end
			if (course == "EC327") {
				EC_327tot = EC_327tot + grade;
				counter1=counter1+1;
			}
			if (course == "EC440") {
				EC_440tot = EC_440tot + grade;
				counter2++;
			}
		}
		if (classname == "EC327") {
			EC_327avg = EC_327tot / counter1;
			return EC_327avg;
		}
		if (classname == "EC440") {
			EC_440avg = EC_440tot / counter2;
			return EC_440avg;
		}
	input.close();

	return 0;
}