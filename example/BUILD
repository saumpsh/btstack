
load("//infrastructure/rules:cc_unconfigured_library.bzl", "cc_unconfigured_library")

cc_unconfigured_library(
  name = "gatt_counter_unconfigured",
  srcs = ["gatt_counter.c"],
  hdrs = ["gatt_counter.h"],
  includes = ["."],
  missing_files = ["btstack_config.h"],
  visibility = ["//visibility:public"],
)
