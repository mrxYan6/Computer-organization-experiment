#include <iostream>
int main () {
    int x = 0x7FFFFFFF;
    std::cout << x << std::endl;
    x = -x;
    for (int i = 0; i < 8; ++i) {
        std::cout << (x & (0xf)) << ' ';
        x >>= 4;
    }
    x += 0x80000000;
    std::cout << std::endl << x << std::endl;
}