#include <stdio.h>
#include <cstddef>

#define DECLARE_SECTION(name)                                                          \
  __attribute__((__visibility__("hidden"),__aligned__(1))) extern const char __start_##name; \
  __attribute__((__visibility__("hidden"),__aligned__(1))) extern const char __stop_##name;

extern "C" {
DECLARE_SECTION(shared_section)
DECLARE_SECTION(another_shared_section)
}

#define PRINT_SECTION(name)                                                          \
  do {                                                                               \
    long int size = &__stop_##name - &__start_##name;                \
    printf(#name "\n");   \
    printf("  start = %ld\n", reinterpret_cast<uintptr_t>(&__start_##name));   \
    printf("  strop = %ld\n", reinterpret_cast<uintptr_t>(&__stop_##name));    \
    printf("  size  = %ld\n", size);                                                   \
  } while (0)

int main(void) {
  PRINT_SECTION(shared_section);
  PRINT_SECTION(another_shared_section);
  return 0;
}
