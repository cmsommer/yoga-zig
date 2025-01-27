const std = @import("std");

const CXXFLAGS = .{
    "--std=c++20",
    "-Wall",
    "-Wextra",
    "-Werror",
};

const files = .{
    "YGConfig.cpp",
    "YGEnums.cpp",
    "YGNode.cpp",
    "YGNodeLayout.cpp",
    "YGNodeStyle.cpp",
    "YGPixelGrid.cpp",
    "YGValue.cpp",
    "algorithm/AbsoluteLayout.cpp",
    "algorithm/Baseline.cpp",
    "algorithm/Cache.cpp",
    "algorithm/CalculateLayout.cpp",
    "algorithm/FlexLine.cpp",
    "algorithm/PixelGrid.cpp",
    "config/Config.cpp",
    "debug/AssertFatal.cpp",
    "debug/Log.cpp",
    "event/event.cpp",
    "node/LayoutResults.cpp",
    "node/Node.cpp",
};

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const yoga_dep = b.dependency("yoga", .{
        .target = target,
        .optimize = optimize,
    });

    const yoga_zig_mod = b.addModule("yoga-zig", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
    });

    const yoga_zig_lib = b.addStaticLibrary(.{
        .name = "yoga-zig",
        .root_module = yoga_zig_mod,
    });

    yoga_zig_lib.addCSourceFiles(.{
        .root = yoga_dep.path("yoga"),
        .files = &files,
        .flags = &CXXFLAGS,
    });

    yoga_zig_lib.installHeadersDirectory(yoga_dep.path("yoga"), "yoga", .{
        .include_extensions = &.{".h"},
    });

    yoga_zig_lib.linkLibCpp();
    yoga_zig_lib.addIncludePath(yoga_dep.path(""));

    b.installArtifact(yoga_zig_lib);

    const yoga_zig_sample = b.addExecutable(.{
        .name = "yoga-zig-sample",
        .root_source_file = b.path("tests/raylib-demo/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    yoga_zig_sample.root_module.addImport("yoga-zig", yoga_zig_mod);

    const run_cmd = b.addRunArtifact(yoga_zig_sample);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib_unit_tests = b.addTest(.{
        .root_module = yoga_zig_mod,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
