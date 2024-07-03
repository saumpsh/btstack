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

## Less scablable approach. We directly include btstack config from projects.
cc_library(
  name = "hci_transport_h2_libusb",
  srcs = ["hci_transport_h2_libusb.c"],
  deps = [
    "//src:btstack",
    "//port/libusb:btstack_config"
  ],
  copts = ["-I/usr/include/libusb-1.0/"],
  visibility = ["//visibility:public"]
)