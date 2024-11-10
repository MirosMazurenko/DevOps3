#include "funcA.h"
#include <cmath>
double FuncA::compute(double x, int n) {
    double result = 0;
    
    for (int i = 1; i <= n; i++) {
        if (i % 2 == 1) {
            result += (i == 1) ? x : (pow(x, i) / ((i % 4 == 3) ? (i - 1) : i));
        }
    }
    
    return result;
}
