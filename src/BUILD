load("//infrastructure/rules:cc_unconfigured_library.bzl", "cc_unconfigured_library")

cc_unconfigured_library(
  name = "btstack_unconfigured",
  srcs = glob(["*.c", "ble/gatt-service/*.c", "ble/*.c", "classic/*.c", "mesh/gatt-service/*.c", "le-audio/*.c", "le-audio/gatt-service/*.c", "mesh/*.c",]),
  hdrs = glob(["*.h", "ble/gatt-service/*.h", "ble/*.h", "classic/*.h", "mesh/gatt-service/*.h", "le-audio/*.h", "le-audio/gatt-service/*.h", "mesh/*.h",]),
  includes = [".", "ble", "classic", "le-audio", "mesh"],
  deps = [
    "//3rd-party/rijndael",
    "//3rd-party/micro-ecc",
    "//3rd-party/bluedroid",
    "//3rd-party/md5",
    "//3rd-party/yxml",
    "//3rd-party/lc3-google",
  ],
  missing_files = ["btstack_config.h"],
  visibility = ["//visibility:public"],
)

cc_library(
  name = "btstack_headers",
  hdrs = glob(["*.h", "ble/gatt-service/*.h", "ble/*.h", "classic/*.h", "mesh/gatt-service/*.h", "le-audio/*.h", "le-audio/gatt-service/*.h", "mesh/*.h",]),
  includes = [".", "ble", "classic", "le-audio", "mesh"],
  visibility = ["//visibility:public"],
)
