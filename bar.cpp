extern "C" {
  int __attribute__((__section__("another_shared_section"),__used__)) value1_in_another_shared_section = 0;
  int __attribute__((__section__("shared_section"),__used__))         value2_in_shared_section = 1;
  int __attribute__((__section__("shared_section"),__used__))         value3_in_shared_section = 2;
}
