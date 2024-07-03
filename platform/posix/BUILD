load("//infrastructure/rules:cc_unconfigured_library.bzl", "cc_unconfigured_library")

cc_unconfigured_library(
  name = "btstack_posix_unconfigured",
  hdrs = glob(["*.h"]),
  srcs = glob(["*.c"]),
  includes = ["."],
  deps = [
    "//src:btstack_headers",
    "//3rd-party/tinydir",
  ],
  missing_files = ["btstack_config.h"],
  visibility = ["//visibility:public"],
)

## Less scablable approach. We directly include btstack config from projects.
# For POSIX ports. btstack config for libusb port, but hci layer can also be changed to uart.
cc_library(
  name = "btstack_posix",
  hdrs = glob(["*.h"]),
  srcs = glob(["*.c"]),
  includes = ["."],
  deps = [
    "//src:btstack",
    "//3rd-party/tinydir",
    "//port/libusb:btstack_config"
  ],
  visibility = ["//visibility:public"],
)