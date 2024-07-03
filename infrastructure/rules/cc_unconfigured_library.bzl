"""
This module contains the implementation for a library similar to cc_library
for which we do not immediately compile it's sources.
"""

load("//infrastructure/rules:cc_shared_providers.bzl", "CcDeferredInfo")
load("//infrastructure/rules:cc_shared_constants.bzl", "CC_CONSTANTS__COMMON_LIBRARY_ATTRIBUTES")
load(
    "//infrastructure/rules:cc_shared_utils.bzl",
    "collect_all_includes",
    "merge_cc_deferred_info_from_deps",
    "parse_file_types_from_srcs",
)

############################################################################################
# Helper Functions
############################################################################################

def _fail_if_unconfigured_library_rule_is_chained(ctx):
    deferred_deps = [dep for dep in ctx.attr.deps if CcDeferredInfo in dep]
    for deferred_dep in deferred_deps:
        # unconfigured targets use the mandatory missing files attribute to specify configuaration files
        # which are currently missing and will provided later by cc_configured target.
        # To prevent chaining of unconfigured targets the dependency of current unconfigured target should not
        # have be a unconfigured target and thus should have missing_files list length as 0.
        if len(deferred_dep[CcDeferredInfo].missing_files.to_list()):
            fail("We cannot chain cc_unconfigured_library targets together")

############################################################################################
# Main Functions
############################################################################################
def _cc_unconfigured_library_impl(ctx):
    ccinfo = cc_common.merge_cc_infos(cc_infos = [dep[CcInfo] for dep in ctx.attr.deps])
    _fail_if_unconfigured_library_rule_is_chained(ctx)
    ccdeferredinfo = merge_cc_deferred_info_from_deps(ctx.attr.deps)
    (source_files, assembly_files, private_headers) = parse_file_types_from_srcs(ctx.files.srcs)
    (_, system_includes) = collect_all_includes(ctx, ccinfo, ctx.attr.includes)

    return [
        CcDeferredInfo(
            srcs = depset(direct = source_files, transitive = [ccdeferredinfo.srcs]),
            assembly = depset(assembly_files, transitive = [ccdeferredinfo.assembly]),
            private_headers = depset(private_headers, transitive = [ccdeferredinfo.private_headers]),
            hdrs = depset(direct = ctx.files.hdrs, transitive = [ccdeferredinfo.hdrs]),
            includes = depset(direct = system_includes, transitive = [ccdeferredinfo.includes]),
            local_defines = depset(ctx.attr.local_defines, transitive = [ccdeferredinfo.local_defines]),
            linkopts = depset(ctx.attr.linkopts, transitive = [ccdeferredinfo.linkopts]),
            missing_files = depset(ctx.attr.missing_files),
            private_header_includes = depset(),
            additional_inputs = depset(ctx.files.additional_inputs),
        ),
        ccinfo,
    ]

cc_unconfigured_library = rule(
    implementation = _cc_unconfigured_library_impl,
    doc = """This rule is essentially a `cc_library` for which we do not immediately compile it's sources.

All attributes provided to this rule are intended to be forwarded and compiled by chaining this rule to a `cc_configured_library`
which contains any missing sources or headers. This is useful as a cache-able replacement for `select` statements that may have
otherwise been used to select between different headers or sources.

Example usage:
```python
cc_unconfigured_library(
    name = "sample",
    srcs = ["sample.c"],
    hdrs = ["sample.h"],
    includes = ["."],
    missing_files = [
        "sample_config.c",
        "sample_config.h"
    ]
)
```
""",
    attrs = dict(
        CC_CONSTANTS__COMMON_LIBRARY_ATTRIBUTES,
        additional_inputs = attr.label_list(
            doc = "Miscellaneous/additional files that should be sandboxed for compilation of srcs",
            allow_files = True,
        ),
        missing_files = attr.string_list(
            doc = "Users of this rule must provide the exact basenames of sources that are required to compile it.",
            mandatory = True,
        ),
        deps = attr.label_list(
            doc = "`cc_library` targets that should be built for this rule.",
            providers = [CcInfo],
        ),
    ),
    provides = [CcInfo],
)
