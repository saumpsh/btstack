load("//infrastructure/rules:cc_configured_library.bzl", "cc_configured_library")

cc_library(
    name = "btstack_config",
    hdrs = ["btstack_config.h"],
    includes = ["."],
    visibility = ["//visibility:public"],
)

cc_configured_library(
    name = "bt_stack_configured",
    hdrs = ["btstack_config.h"],
    includes = ["."],
    unconfigured_dep = "//src:btstack_unconfigured"
)

cc_configured_library(
    name = "bt_stack_posix_configured",
    hdrs = ["btstack_config.h"],
    includes = ["."],
    unconfigured_dep = "//platform/posix:btstack_posix_unconfigured"
)

cc_configured_library(
    name = "gatt_counter_lib_configured",
    hdrs = ["btstack_config.h"],
    includes = ["."],
    unconfigured_dep = "//example:gatt_counter_unconfigured",
    deps = ["bt_stack_posix_configured", "bt_stack_configured"],
)

cc_configured_library(
    name = "btstack_chipset_realtek_configured",
    hdrs = ["btstack_config.h"],
    includes = ["."],
    unconfigured_dep = "//chipset/realtek:btstack_chipset_realtek_unconfigured",
    deps = ["bt_stack_posix_configured", "bt_stack_configured"],
)

cc_configured_library(
    name = "btstack_chipset_zephyr_configured",
    hdrs = ["btstack_config.h"],
    includes = ["."],
    unconfigured_dep = "//chipset/zephyr:btstack_chipset_zephyr_unconfigured",
    deps = ["bt_stack_posix_configured", "bt_stack_configured"],
)

cc_configured_library(
    name = "hci_transport_h2_libusb_configured",
    hdrs = ["btstack_config.h"],
    includes = ["."],
    unconfigured_dep = "//platform/libusb:hci_transport_h2_libusb_unconfigured",
    deps = ["bt_stack_posix_configured", "bt_stack_configured"],
    copts = ["-I/usr/include/libusb-1.0/"],
)

cc_binary(
  name = "gatt_counter",
  srcs = ["main.c"],
  deps = [
    ":gatt_counter_lib_configured",
    ":btstack_chipset_realtek_configured",
    ":btstack_chipset_zephyr_configured",
    ":hci_transport_h2_libusb_configured",
    "//platform/embedded:hal_led"
  ],
  linkopts = ["-lusb-1.0"]
)

cc_binary(
  name = "gatt_streamer_server_app",
  srcs = ["main.c"],
  deps = [
    "//example:gatt_streamer_server",
    "//chipset/realtek:btstack_chipset_realtek",
    "//chipset/zephyr:btstack_chipset_zephyr",
    "//platform/libusb:hci_transport_h2_libusb",
    "//platform/embedded:hal_led",
    "//platform/posix:btstack_posix",
  ],
  linkopts = ["-lusb-1.0"]
)

cc_binary(
  name = "gatt_streamer_client_app",
  srcs = ["main.c"],
  deps = [
    "//example:le_streamer_client",
    "//chipset/realtek:btstack_chipset_realtek",
    "//chipset/zephyr:btstack_chipset_zephyr",
    "//platform/libusb:hci_transport_h2_libusb",
    "//platform/embedded:hal_led",
    "//platform/posix:btstack_posix",
  ],
  linkopts = ["-lusb-1.0"]
)
