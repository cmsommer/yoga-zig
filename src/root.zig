const c = @import("./c_api.zig");
pub const enums = @import("./enums.zig");

pub const Value = struct {
    value: f32,
    unit: enums.Unit,
};

pub const Config = struct {
    handle: c.YGConfigRef,

    fn free(self: Config) void {
        c.YGConfigFree(self);
    }
    fn isExperimentalFeatureEnabled(self: Config, feature: enums.ExperimentalFeature) bool {
        return c.YGConfigIsExperimentalFeatureEnabled(self.handle, feature);
    }
    fn setExperimentalFeatureEnabled(self: Config, feature: enums.ExperimentalFeature, enabled: bool) void {
        c.YGConfigSetExperimentalFeatureEnabled(self.handle, feature, enabled);
    }
    fn setPointScaleFactor(self: Config, factor: f32) void {
        c.YGConfigSetPointScaleFactor(self.handle, factor);
    }
    fn getErrata(self: Config) enums.Errata {
        return c.YGConfigGetErrata(self.handle);
    }
    fn setErrata(self: Config, errata: enums.Errata) void {
        c.YGConfigSetErrata(self.handle, errata);
    }
    fn getUseWebDefaults(self: Config) bool {
        return c.YGConfigGetUseWebDefaults(self);
    }
    fn setUseWebDefaults(self: Config, useWebDefaults: bool) void {
        c.YGConfigSetUseWebDefaults(self.handle, useWebDefaults);
    }
};

pub const Node = struct {
    handle: c.YGNodeRef,

    pub fn initDefault() Node {
        return .{
            .handle = c.YGNodeNew(),
        };
    }

    pub fn initWithConfig(config: Config) Node {
        return .{
            .handle = c.YGNodeNewWithConfig(config.handle),
        };
    }

    pub fn free(self: Node) void {
        c.YGNodeFree(self.handle);
    }
    pub fn freeRecursive(self: Node) void {
        c.YGNodeFreeRecursive(self.handle);
    }

    pub fn calculateLayout(self: Node, availableWidth: ?f32, availableHeight: ?f32, ownerDirection: ?enums.Direction) void {
        const ygDir = @as(c_uint, @intFromEnum(ownerDirection orelse enums.Direction.Inherit));
        c.YGNodeCalculateLayout(self.handle, availableWidth orelse 0.0, availableHeight orelse 0.0, ygDir);
    }

    pub fn getFlexDirection(self: Node) enums.FlexDirection {
        const ygValue = c.YGNodeStyleGetFlexDirection(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn setFlexDirection(self: Node, dir: enums.FlexDirection) void {
        c.YGNodeStyleSetFlexDirection(self.handle, @intFromEnum(dir));
    }

    pub fn getWidth(self: Node) Value {
        const ygValue = c.YGNodeStyleGetWidth(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn setWidth(self: Node, size: f32) void {
        c.YGNodeStyleSetWidth(self.handle, size);
    }

    pub fn setHeight(self: Node, size: f32) void {
        c.YGNodeStyleSetHeight(self.handle, size);
    }

    pub fn setFlexGrow(self: Node, amount: f32) void {
        c.YGNodeStyleSetFlexGrow(self.handle, amount);
    }

    pub fn setMargin(self: Node, edge: enums.Edge, size: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetMargin(self.handle, ygEdge, size);
    }

    pub fn insertChild(self: Node, child: Node, index: usize) void {
        c.YGNodeInsertChild(self.handle, child.handle, index);
    }
};
