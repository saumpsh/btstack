load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

exports_files([
    "cc_configured_library.bzl",
    "cc_unconfigured_library.bzl",
])

bzl_library(
    name = "configured_library_sources",
    srcs = [
        "cc_configured_library.bzl",
        "cc_unconfigured_library.bzl",
    ],
    visibility = ["//visibility:public"],
)
