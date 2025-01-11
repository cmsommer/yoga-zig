const std = @import("std");

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

    const yoga_zig_lib = b.addStaticLibrary(.{
        .name = "zig-yoga",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const yoga_zig_mod = b.addModule("zig-yoga", .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    yoga_zig_lib.installHeadersDirectory(yoga_dep.path("yoga"), "yoga", .{
        .include_extensions = &.{".h"},
    });
    yoga_zig_lib.linkLibC();
    yoga_zig_lib.linkLibCpp();

    const yoga_compile_run = b.addSystemCommand(&.{
        "cmake",
        yoga_dep.path("").getPath(b),
        "-B",
        yoga_dep.path("build").getPath(b),
        "-G",
        "Ninja",
    });
    b.default_step.dependOn(&yoga_compile_run.step);

    const yoga_compile_build_run = b.addSystemCommand(&.{
        "cmake",
        "--build",
        yoga_dep.path("build").getPath(b),
    });

    b.default_step.dependOn(&yoga_compile_build_run.step);

    const lib: []const u8 = if (target.result.os.tag == .windows and target.result.abi == .msvc) "yoga/yogacore.lib" else "yoga/libyogacore.a";
    const lib_path = std.fmt.allocPrint(b.allocator, "{s}/{s}", .{
        yoga_dep.path("build").getPath(b),
        lib,
    }) catch unreachable;

    yoga_zig_mod.addIncludePath(yoga_dep.path(""));
    yoga_zig_mod.addAssemblyFile(.{ .cwd_relative = lib_path });
    yoga_zig_mod.linkLibrary(yoga_zig_lib);

    b.installArtifact(yoga_zig_lib);

    const exe = b.addExecutable(.{
        .name = "zig-yoga",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibrary(yoga_zig_lib);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
