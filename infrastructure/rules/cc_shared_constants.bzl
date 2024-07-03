"""
This module contains definition of various common CC library attributes and file extensions
"""

# Valid extensions for various types of files, following (not including) the rightmost period.
CC_CONSTANTS_VALID_EXTENSIONS = {
    "cxx": ("hh", "hpp", "cc", "cxx", "cpp"),
    "c": ("h", "c"),
    "header": ("h", "hh", "hpp", "ipp"),
    "source": ("c", "cc", "cpp"),
    "assembly": ("asm", "s", "S"),
}

# These are common attributes that should be available for all cc_*_library rules to maintain a consistent api.
CC_CONSTANTS__COMMON_LIBRARY_ATTRIBUTES = {
    "srcs": attr.label_list(
        allow_files = True,
        doc = """Source files to compile. Header files intended to be private may also be added here.

If used on test rules, test source files must follow the format; test_*.c""",
    ),
    "hdrs": attr.label_list(
        allow_files = True,
        doc = "List of headers to compile with ",
    ),
    "includes": attr.string_list(
        doc = """"List of include dirs to be added to the compile line.

Each string is prepended with -isystem and added to COPTS. Unlike COPTS, these flags are added for this rule and every
rule that depends on it. (Note: not the rules it depends upon!) Be very careful, since this may have far-reaching
effects. When in doubt, add "-I" flags to COPTS instead.

This field should not be typically required since this rule will automatically generate include paths based on supplied
header files.

Headers must still be added to srcs or hdrs, otherwise they will not be available to dependent rules when compilation
is sandboxed.""",
    ),
    "local_defines": attr.string_list(
        doc = "Local defines are applied to compile actions in this rule instance only and are not inherited transitively",
    ),
    "defines": attr.string_list(
        doc = """A list of defines to be added to the compilation command line. Defines are inherited transitively,
consider using `local_defines` if you do not require this. Each item will be prefixed with `-D`.""",
    ),
    "copts": attr.string_list(
        doc = """Add these options to the C++ compilation command.

Each string in this attribute is added in the given order to COPTS before compiling the binary target. The flags take
effect only for compiling this target, not its dependencies, so be careful about header files included elsewhere. All
paths should be relative to the workspace, not to the current package.""",
    ),
    "linkopts": attr.string_list(
        doc = "A list of additional link options to apply",
    ),
    "data": attr.label_list(
        allow_files = True,
        doc = "Data that should be added to this rule's runfiles",
    ),
}
