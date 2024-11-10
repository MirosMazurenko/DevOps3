#include <iostream>
#include <cassert>
#include <cmath>
#include <stdio.h>
#include "../funcA.h"


void testCompute() {
    FuncA func;
    double x = 0.5;
    int n = 3;
    double result1 = func.compute(x, n);
    double expected1 = 0.5625;

    
    std::cout << "Computed result: " << result1 << std::endl;
    std::cout << "Expected result: " << expected1 << std::endl;
    
    assert(fabs(result1 - expected1) < 1e-3 && "Test failed for x = 0.5, n = 3");
}

int main() {
    testCompute();
    return 0;
}
