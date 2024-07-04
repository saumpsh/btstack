
load("//infrastructure/rules:cc_unconfigured_library.bzl", "cc_unconfigured_library")

cc_unconfigured_library(
  name = "gatt_counter_unconfigured",
  srcs = ["gatt_counter.c"],
  hdrs = ["gatt_counter.h"],
  includes = ["."],
  missing_files = ["btstack_config.h"],
  visibility = ["//visibility:public"],
)

## Less scablable approach. We directly include btstack config from projects.
cc_library(
  name = "gatt_counter",
  srcs = ["gatt_counter.c"],
  hdrs = ["gatt_counter.h"],
  includes = ["."],
  deps = [
    "//port/libusb:btstack_config",
    "//src:btstack",
  ],
  visibility = ["//visibility:public"],
)

cc_library(
  name = "gatt_streamer_server",
  srcs = ["gatt_streamer_server.c"],
  hdrs = ["gatt_streamer_server.h"],
  includes = ["."],
  deps = [
    "//port/libusb:btstack_config",
    "//src:btstack",
  ],
  visibility = ["//visibility:public"],
)

cc_library(
  name = "le_streamer_client",
  srcs = ["le_streamer_client.c"],
  includes = ["."],
  deps = [
    "//port/libusb:btstack_config",
    "//src:btstack",
  ],
  visibility = ["//visibility:public"],
)