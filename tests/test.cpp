#include <iostream>
#include <cassert>
#include <cmath>
#include <stdio.h>
#include "../funcA.h"


void testComputePerformance() {
    FuncA func;
    std::vector<double> aValues;
    aValues.reserve(2000000);

    for (int i = 0; i < 2000000; i++) {
        aValues.push_back(func.compute(0.5, 5));
    }

    auto t1 = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < 1200; i++) {
        std::sort(aValues.begin(), aValues.end());
    }
    auto t2 = std::chrono::high_resolution_clock::now();
    auto elapsed_ms = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1).count();

    assert(elapsed_ms >= 5000 && elapsed_ms <= 20000 && "Performance test failed");
}

int main() {
    testCompute();
    testComputePerformance();
    return 0;
}
