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
