"""Custom Providers"""

CcDeferredInfo = provider(
    doc = "This provider is essentially a clone of CcInfo that exists to allow us to defer compilation across rules",
    fields = {
        "srcs": "Depset of source files",
        "assembly": "Depset of assembly files",
        "hdrs": "Depset of header files",
        "private_headers": "Depset of  headers that were supplied through srcs",
        "private_header_includes": "Depset of header includes needed to compile deferred targets",
        "includes": "Depset of include paths passed in through ctx.attr.includes",
        "linkopts": "Depset of link options to be passed to the linker",
        "local_defines": "Depset of unformatted macros we would like to define",
        "missing_files": "Depset of a list of files which are needed to compile the sources in this provider",
        "additional_inputs": "Depset of Miscellaneous/additional files that should be sandboxed for compilation of srcs",
    },
)
