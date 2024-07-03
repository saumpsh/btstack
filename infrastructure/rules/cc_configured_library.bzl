"""
This module contains implementation for unconfigured cc_library support.
"""

load("//infrastructure/rules:cc_shared_providers.bzl", "CcDeferredInfo")
load("//infrastructure/rules:cc_shared_constants.bzl", "CC_CONSTANTS__COMMON_LIBRARY_ATTRIBUTES")
load(
    "//infrastructure/rules:cc_shared_utils.bzl",
    "collect_all_includes",
    "configure_toolchain_features",
    "parse_file_types_from_srcs",
    "sibros_find_cpp_toolchain",
)

############################################################################################
# Helper Functions
############################################################################################

def _check_missing_file_speficfied_by_cc_unconfigured_library_is_present(ctx, source_files, private_headers, ccinfo):
    provided_file_basenames = [file.basename for file in ctx.files.hdrs + private_headers]
    provided_file_basenames += [file.basename for file in source_files]
    provided_file_basenames += [hdr.basename for hdr in ccinfo.compilation_context.headers.to_list()]

    for file in ctx.attr.unconfigured_dep[CcDeferredInfo].missing_files.to_list():
        if not file in provided_file_basenames:
            fail("The `cc_unconfigured_library` that you are attempting to compile requires {}, but {} has not provided this file.".format(file, ctx.label.name))

############################################################################################
# Main Function
############################################################################################

def _cc_configured_library_impl(ctx):
    cc_toolchain = sibros_find_cpp_toolchain(ctx)
    ccinfo = cc_common.merge_cc_infos(cc_infos = [ctx.attr.unconfigured_dep[CcInfo]] + [dep[CcInfo] for dep in ctx.attr.deps])

    (source_files, assembly_files, private_headers) = parse_file_types_from_srcs(ctx.files.srcs)
    (quote_includes, system_includes) = collect_all_includes(ctx, ccinfo, ctx.attr.includes)

    _check_missing_file_speficfied_by_cc_unconfigured_library_is_present(ctx, source_files, private_headers, ccinfo)

    headers_depset = depset(
        direct = ctx.files.hdrs + private_headers,
        transitive = [
            ccinfo.compilation_context.headers,
            ctx.attr.unconfigured_dep[CcDeferredInfo].hdrs,
            ctx.attr.unconfigured_dep[CcDeferredInfo].private_headers,
        ],
    )
    include_dir_depset = depset(direct = system_includes, transitive = [ctx.attr.unconfigured_dep[CcDeferredInfo].includes])

    feature_configuration = configure_toolchain_features(ctx, cc_toolchain)
    (compile_context, compile_outputs) = cc_common.compile(
        actions = ctx.actions,
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        srcs = source_files + ctx.attr.unconfigured_dep[CcDeferredInfo].srcs.to_list() + assembly_files + ctx.attr.unconfigured_dep[CcDeferredInfo].assembly.to_list(),
        public_hdrs = headers_depset.to_list(),
        system_includes = include_dir_depset.to_list(),
        quote_includes = quote_includes,
        compilation_contexts = [ccinfo.compilation_context],
        name = ctx.label.name,
        user_compile_flags = ctx.attr.copts,
        defines = ctx.attr.defines,
        local_defines = ctx.attr.local_defines + ctx.attr.unconfigured_dep[CcDeferredInfo].local_defines.to_list(),
        additional_inputs = ctx.attr.unconfigured_dep[CcDeferredInfo].additional_inputs.to_list(),
    )

    (link_context, link_outputs) = cc_common.create_linking_context_from_compilation_outputs(
        actions = ctx.actions,
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        compilation_outputs = compile_outputs,
        name = ctx.label.name,
        user_link_flags = ctx.attr.linkopts + ctx.attr.unconfigured_dep[CcDeferredInfo].linkopts.to_list(),
    )

    ccinfo_new = cc_common.merge_cc_infos(cc_infos = [CcInfo(compilation_context = compile_context, linking_context = link_context), ccinfo])

    providers = [
        ccinfo_new,
    ]
    if link_outputs.library_to_link:
        providers.append(DefaultInfo(files = depset(link_outputs.library_to_link.objects + link_outputs.library_to_link.pic_objects)))

    return providers

cc_configured_library = rule(
    implementation = _cc_configured_library_impl,
    doc = """This rule requires a single `cc_unconfigured_library` which we will compile.

All files required to compile the dependent `unconfigured_dep` must be provided by this rule.

Example usage:
```python
cc_configured_library(
    name = "configured_sample",
    srcs = ["sample_config.c"],
    hdrs = ["sample_config.h"],
    includes = ["."],
    unconfigured_dep = "//path/to/sample:sample"
) # where sample is the unconfigured_library
```
""",
    attrs = dict(
        CC_CONSTANTS__COMMON_LIBRARY_ATTRIBUTES,
        unconfigured_dep = attr.label(
            doc = "A single dependency of type `cc_unconfigured_library` that will be configured and compiled by this rule.",
            providers = [CcInfo, CcDeferredInfo],
            mandatory = True,
        ),
        deps = attr.label_list(
            doc = "`cc_library` targets that should be built for this rule.",
            providers = [CcInfo],
        ),
        _cc_toolchain = attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    ),
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
    fragments = ["cpp"],
    provides = [CcInfo],
)
