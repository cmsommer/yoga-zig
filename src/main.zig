const std = @import("std");
// const yoga = @import("zig-yoga");
const yoga = @import("./c_api.zig");

pub fn main() !void {
    const root = yoga.Node.init();
    _ = root; // autofix
}
