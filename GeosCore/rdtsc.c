#include <stdint.h>

inline uint64_t rdtsc()
{
    uint32_t lo, hi;
    __asm__ __volatile__(
        "rdtsc"              // Execute RDTSC instruction
        : "=a"(lo), "=d"(hi) // Output: EAX -> lo, EDX -> hi
    );
    return ((uint64_t)hi << 32) | lo; // Combine high and low 32 bits into 64 bits
}