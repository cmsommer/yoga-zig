const c = @cImport({
    @cInclude("yoga/Yoga.h");
});

pub const Node = struct {
    handle: c.YGNodeRef,

    pub fn init() Node {
        return .{
            .handle = c.YGNodeNew(),
        };
    }
};
