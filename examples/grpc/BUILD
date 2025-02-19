package(default_visibility = ["//visibility:public"])

load("@rules_proto//proto:defs.bzl", "proto_library")
load("@com_github_grpc_grpc//bazel:cc_grpc_library.bzl", "cc_grpc_library")

proto_library(
    name = "messages_proto",
    srcs = ["protos/messages.proto"],
)

cc_proto_library(
    name = "messages_cc_proto",
    deps = [":messages_proto"],
)

cc_grpc_library(
    name = "messages_cc_grpc",
    srcs = [":messages_proto"],
    grpc_only = True,
    deps = [":messages_cc_proto"],
)

cc_library(
    name = "tracer_common",
    srcs = ["tracer_common.h"],
    defines = ["BAZEL_BUILD"],
    deps = [
        "//exporters/ostream:ostream_span_exporter",
    ],
)

cc_binary(
    name = "client_grpc",
    srcs = [
        "client.cpp",
    ],
    defines = ["BAZEL_BUILD"],
    deps = [
        "messages_cc_grpc",
        ":tracer_common",
        "//api",
        "//sdk/src/trace",
        "@com_github_grpc_grpc//:grpc++",
    ],
)

cc_binary(
    name = "server_grpc",
    srcs = [
        "server.cpp",
    ],
    defines = ["BAZEL_BUILD"],
    deps = [
        "messages_cc_grpc",
        ":tracer_common",
        "//api",
        "//sdk/src/trace",
        "@com_github_grpc_grpc//:grpc++",
    ],
)
