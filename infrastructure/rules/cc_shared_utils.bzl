"""
This file contains common C/C++ helper functions

Functions in this file are intended to assist starlark development, NOT for use in BUILD files.
"""

load("//infrastructure/rules:cc_shared_providers.bzl", "CcDeferredInfo")
load("//infrastructure/rules:cc_shared_constants.bzl", "CC_CONSTANTS_VALID_EXTENSIONS")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")
# load("//infrastructure/bazel/shared/unixpath:unixpath.bzl", "unixpath")
# load("//infrastructure/bazel/repo_rules/toolchains/cc/shared:cc_toolchain_constants.bzl", "CLANG_TOOLCHAIN_TARGET_TRIPLET")
# load("@bazel_skylib//lib:new_sets.bzl", "sets")

_BLOCK_NETWORK_TAG = "block-network"
_REQUIRES_NETWORK_TAG = "requires-network"
_SEP = "/"

def parse_file_types_from_srcs(srcs):
    """Iterates through a list of files, separates private headers, sources, and assembly files

    Args:
        srcs: a label_list of source files
    Returns:
        a tuple of label_lists; (source files label_list, assembly_files_list label_list, private headers label_list)
    """
    source_files_list = []
    private_headers_list = []
    assembly_files_list = []
    for source_file in srcs:
        if source_file.extension in CC_CONSTANTS_VALID_EXTENSIONS["header"]:
            private_headers_list.append(source_file)
        elif source_file.extension in CC_CONSTANTS_VALID_EXTENSIONS["source"]:
            source_files_list.append(source_file)
        elif source_file.extension in CC_CONSTANTS_VALID_EXTENSIONS["assembly"]:
            assembly_files_list.append(source_file)
        else:
            fail("{source_file} is not a supported source file. Supported extensions: {supported_extensions}".format(
                source_file = source_file.path,
                supported_extensions = (CC_CONSTANTS_VALID_EXTENSIONS),
            ))

    return (source_files_list, assembly_files_list, private_headers_list)

def collect_all_includes(ctx, ccinfo, includes):
    """Collects all includes fields from a rules ctx.attr.includes and it's dependencies

    Args:
        ctx: rule context
        ccinfo: CcInfo provider to search for includes
        includes: ctx.attr.includes to collect fields from
    Returns:
        a tuple of list (quote_includes, system_includes)
    """

    # Include the current directory of the rule by default
    system_includes = []
    system_includes += [
        ctx.label.workspace_root + ctx.label.package + _SEP + include.replace(".", "", 1)
        for include in includes
    ]
    system_includes += [ctx.genfiles_dir.path + _SEP + include for include in system_includes]
    system_includes += ccinfo.compilation_context.system_includes.to_list()

    quote_includes = ccinfo.compilation_context.quote_includes.to_list()

    return (quote_includes, system_includes)

def merge_cc_deferred_info_from_deps(deps):
    """Merges all CcDeferredInfo providers from a list of dependencies.

    Args:
        deps list of attr.deps
    Returns:
        CcDeferredInfo of merged deps
    """
    return CcDeferredInfo(
        srcs = depset(transitive = [dep[CcDeferredInfo].srcs for dep in deps if CcDeferredInfo in dep]),
        assembly = depset(transitive = [dep[CcDeferredInfo].assembly for dep in deps if CcDeferredInfo in dep and hasattr(dep[CcDeferredInfo], "assembly")]),
        hdrs = depset(transitive = [dep[CcDeferredInfo].hdrs for dep in deps if CcDeferredInfo in dep]),
        private_headers = depset(transitive = [dep[CcDeferredInfo].private_headers for dep in deps if CcDeferredInfo in dep]),
        private_header_includes = depset(transitive = [dep[CcDeferredInfo].private_header_includes for dep in deps if CcDeferredInfo in dep]),
        includes = depset(transitive = [dep[CcDeferredInfo].includes for dep in deps if CcDeferredInfo in dep and hasattr(dep[CcDeferredInfo], "includes")]),
        local_defines = depset(transitive = [dep[CcDeferredInfo].local_defines for dep in deps if CcDeferredInfo in dep]),
        linkopts = depset(transitive = [dep[CcDeferredInfo].linkopts for dep in deps if CcDeferredInfo in dep]),
    )

def configure_toolchain_features(ctx, cc_toolchain, disabled_features = [], requested_features = []):
    """Helper function for toolchain feature setup

    Args:
        ctx: rule context
        cc_toolchain: toolchain to configure features for
        disabled_features: optional list of toolchain features that should not be configured
        requested_features: optional list of toolchain features that should be configured
    Returns:
        the toolchain feature configuration
    """
    return cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features + requested_features,
        unsupported_features = ctx.disabled_features + disabled_features,
    )

# Modified version of find_cc_toolchain in @rules_cc//cc:find_cc_toolchain.bzl
# Checks for @bazel_tools//tools/cpp:toolchain_type instead of //cc:toolchain_type
# since that function does not work outside of rules_cc
def sibros_find_cpp_toolchain(ctx):
    """
    Finds a cc toolchain given a rule context

    Args:
        ctx: The current context
    Returns:
        a cpp toolchain, if it exists
    """

    # Check the incompatible flag for toolchain resolution.
    if hasattr(cc_common, "is_cc_toolchain_resolution_enabled_do_not_use") and cc_common.is_cc_toolchain_resolution_enabled_do_not_use(ctx = ctx):
        if "@bazel_tools//tools/cpp:toolchain_type" in ctx.toolchains:
            return ctx.toolchains["@bazel_tools//tools/cpp:toolchain_type"].cc
        fail("Toolchain resolution is enabled, however no applicable toolchains could be found.")
    else:
        return find_cpp_toolchain(ctx)
