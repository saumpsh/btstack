load("//infrastructure/rules:cc_configured_library.bzl", "cc_configured_library")

cc_configured_library(
    name = "bt_stack_configured",
    hdrs = ["btstack_config.h"],
    includes = ["."],
    unconfigured_dep = "//src:btstack"
)