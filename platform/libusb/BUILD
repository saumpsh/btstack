load("//infrastructure/rules:cc_unconfigured_library.bzl", "cc_unconfigured_library")

cc_unconfigured_library(
  name = "hci_transport_h2_libusb_unconfigured",
  srcs = ["hci_transport_h2_libusb.c"],
  deps = [
    "//src:btstack_headers",
  ],
  copts = ["-I/usr/include/libusb-1.0/"],
  missing_files = ["btstack_config.h"],
  visibility = ["//visibility:public"]
)
