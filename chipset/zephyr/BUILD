load("//infrastructure/rules:cc_unconfigured_library.bzl", "cc_unconfigured_library")

cc_unconfigured_library(
  name = "btstack_chipset_zephyr",
  srcs = ["btstack_chipset_zephyr.c"],
  hdrs = ["btstack_chipset_zephyr.h"],
  includes = ["."],
  missing_files = ["btstack_config.h"],
  visibility = ["//visibility:public"]
)
