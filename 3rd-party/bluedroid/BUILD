cc_library(
  name = "bluedroid",
  srcs = glob(["encoder/srce/*.c", "decoder/srce/*.c",]) + ["decoder/srce/readsamplesjoint.inc",],
  hdrs = glob(["encoder/include/*.h", "decoder/include/*.h",]),
  includes = ["encoder/include", "decoder/include"],
  visibility = ["//visibility:public",],
)
