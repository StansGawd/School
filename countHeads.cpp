int choose(int N, int r){
    int result_N = 1, result_r = 1, nrr = 1;
    int nr;
    int total;
    for (int i = (r + 1); i <= N; i++) {//Regular Factorial for N, plus one because being cancelled
        result_N = result_N * i;
    }

    /*
    for(int j=1; j <= r ;j++){//Regular Factorial for r
       result_r=result_r*j;
    }
    */

    nr = N - r;
    for (int k = 1; k <= nr; k++) {//Regular Factorial for (n-r)
        nrr = nrr * k;
    }
    //Put into the fraction
    total = result_N / (result_r * nrr);

  return total;

}
