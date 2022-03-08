#include "iostream"
#include "countHeads.h"
using namespace std;

int main (){
  cout << "How many coins would you like to flip? ";
  int coins;
  cin >> coins;
  cout << "How many heads do you want? ";
  int heads;
  cin >> heads;
  int ways= choose(coins, heads);
  cout<< "Flipping "<<coins<<" coins, we can get "<< heads<< " heads "<< ways<<" ways." << endl;
  cout<<"Flip again? ";
  char again;
  cin >>again;

  if(again == 'y'){
  while(again == 'y'){
    cout << "How many coins would you like to flip? ";
    cin >> coins;
    cout << "How many heads do you want? ";
    cin >> heads;
    ways= choose(coins, heads);
    cout<< "Flipping "<<coins<<" coins, we can get "<< heads<< " heads "<< ways<<" ways." << endl;
    cout<<"Flip again? ";  
    cin >> again;
  }
  }
  return 0;
}
