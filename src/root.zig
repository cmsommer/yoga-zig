const c = @import("./c_api.zig");
pub const enums = @import("./enums.zig");

pub const Value = struct {
    value: f32,
    unit: enums.Unit,
};

pub const Layout = struct {
    left: f32,
    right: f32,
    top: f32,
    bottom: f32,
    width: f32,
    height: f32,
};

pub const Basis = union(enum) {
    number: f32,
    percent: f32,
    auto,
    fitContent,
    maxContent,
    stretch,
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

    pub fn copyStyle(self: Node) void {
        c.YGNodeCopyStyle(self.handle);
    }

    pub fn calculateLayout(self: Node, availableWidth: ?f32, availableHeight: ?f32, ownerDirection: ?enums.Direction) void {
        const ygDir = @as(c_uint, @intFromEnum(ownerDirection orelse enums.Direction.Inherit));
        c.YGNodeCalculateLayout(self.handle, availableWidth orelse 0.0, availableHeight orelse 0.0, ygDir);
    }

    pub fn getChildCount(self: Node) usize {
        return c.YGNodeGetChildCount(self.handle);
    }
    pub fn getChild(self: Node, index: usize) Node {
        const ygNode = c.YGNodeGetChild(self.handle, index);
        return .{ .handle = ygNode };
    }

    pub fn getFlexDirection(self: Node) enums.FlexDirection {
        const ygValue = c.YGNodeStyleGetFlexDirection(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }

    pub fn getWidth(self: Node) Value {
        const ygValue = c.YGNodeStyleGetWidth(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }

    pub fn getHeight(self: Node) Value {
        const ygValue = c.YGNodeStyleGetHeight(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn insertChild(self: Node, child: Node, index: usize) void {
        c.YGNodeInsertChild(self.handle, child.handle, index);
    }

    pub fn getComputedBorder(self: Node, edge: enums.Edge) f32 {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        return c.YGNodeLayoutGetBorder(self.handle, ygEdge);
    }
    pub fn getComputedLayout(self: Node) Layout {
        const left = c.YGNodeLayoutGetLeft(self.handle);
        const right = c.YGNodeLayoutGetRight(self.handle);
        const top = c.YGNodeLayoutGetTop(self.handle);
        const bottom = c.YGNodeLayoutGetBottom(self.handle);
        const width = c.YGNodeLayoutGetWidth(self.handle);
        const height = c.YGNodeLayoutGetHeight(self.handle);

        return .{
            .left = left,
            .right = right,
            .top = top,
            .bottom = bottom,
            .width = width,
            .height = height,
        };
    }
    pub fn getComputedMargin(self: Node, edge: enums.Edge) f32 {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        return c.YGNodeLayoutGetMargin(self.handle, ygEdge);
    }
    pub fn getComputedPadding(self: Node, edge: enums.Edge) f32 {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        return c.YGNodeLayoutGetPadding(self.handle, ygEdge);
    }
    pub fn getComputedWidth(self: Node) f32 {
        return c.YGNodeLayoutGetWidth(self.handle);
    }
    pub fn getComputedHeight(self: Node) f32 {
        return c.YGNodeLayoutGetWidth(self.handle);
    }
    pub fn getComputedLeft(self: Node) f32 {
        return c.YGNodeLayoutGetLeft(self.handle);
    }
    pub fn getComputedTop(self: Node) f32 {
        return c.YGNodeLayoutGetTop(self.handle);
    }
    pub fn getComputedRight(self: Node) f32 {
        return c.YGNodeLayoutGetRight(self.handle);
    }
    pub fn getComputedBottom(self: Node) f32 {
        return c.YGNodeLayoutGetBottom(self.handle);
    }

    pub fn getAlignContent(self: Node) enums.Align {
        const ygValue = c.YGNodeStyleGetAlignContent(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getAlignItems(self: Node) enums.Align {
        const ygValue = c.YGNodeStyleGetAlignItems(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getAlignSelf(self: Node) enums.Align {
        const ygValue = c.YGNodeStyleGetAlignSelf(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getAspectRatio(self: Node) f32 {
        return c.YGNodeStyleGetAspectRatio(self.handle);
    }
    pub fn getBorder(self: Node, edge: enums.Edge) f32 {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        return c.YGNodeStyleGetBorder(self.handle, ygEdge);
    }

    pub fn getDirection(self: Node) enums.Direction {
        const ygValue = c.YGNodeStyleGetDirection(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getDisplay(self: Node) enums.Display {
        const ygValue = c.YGNodeStyleGetDisplay(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getFlexBasis(self: Node) Value {
        const ygValue = c.YGNodeStyleGetFlexBasis(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }

    pub fn getFlexGrow(self: Node) f32 {
        return c.YGNodeStyleGetFlexGrow(self.handle);
    }
    pub fn getFlexShrink(self: Node) f32 {
        return c.YGNodeStyleGetFlexShrink(self.handle);
    }
    pub fn getFlexWrap(self: Node) enums.Wrap {
        const ygValue = c.YGNodeStyleGetFlexWrap(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }

    pub fn getJustifyContent(self: Node) enums.Justify {
        const ygValue = c.YGNodeStyleGetJustifyContent(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }

    pub fn getGap(self: Node, gutter: enums.Gutter) Value {
        const ygValue = c.YGNodeStyleGetGap(self.handle, @intFromEnum(gutter));
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMargin(self: Node, edge: enums.Edge) Value {
        const ygValue = c.YGNodeStyleGetMargin(self.handle, @intFromEnum(edge));
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMaxHeight(self: Node) Value {
        const ygValue = c.YGNodeStyleGetMaxHeight(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMaxWidth(self: Node) Value {
        const ygValue = c.YGNodeStyleGetMaxWidth(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMinHeight(self: Node) Value {
        const ygValue = c.YGNodeStyleGetMinHeight(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMinWidth(self: Node) Value {
        const ygValue = c.YGNodeStyleGetMinWidth(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getOverflow(self: Node) enums.Overflow {
        const ygValue = c.YGNodeStyleGetOverflow(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getPadding(self: Node, edge: enums.Edge) Value {
        const ygValue = c.YGNodeStyleGetPadding(self.handle, @intFromEnum(edge));
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getParent(self: Node) ?Node {
        const ygNode = c.YGNodeGetParent(self.handle);
        if (ygNode == null) {
            return null;
        }
        return .{ .handle = ygNode };
    }
    pub fn getPosition(self: Node, edge: enums.Edge) Value {
        const ygValue = c.YGNodeStyleGetPosition(self.handle, @intFromEnum(edge));
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getPositionType(self: Node) enums.PositionType {
        const ygValue = c.YGNodeStyleGetPositionType(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getBoxSizing(self: Node) enums.BoxSizing {
        const ygValue = c.YGNodeStyleGetBoxSizing(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn isDirty(self: Node) bool {
        return c.YGNodeIsDirty(self.handle);
    }
    pub fn isReferenceBaseline(self: Node) bool {
        return c.YGNodeIsReferenceBaseline(self.handle);
    }
    pub fn markDirty(self: Node) void {
        c.YGNodeMarkDirty(self.handle);
    }
    pub fn hasNewLayout(self: Node) bool {
        return c.YGNodeHasNewLayout(self.handle);
    }
    pub fn markLayoutSeen(self: Node) void {
        c.YGNodeMarkLayoutSeen(self.handle);
    }
    pub fn removeChild(self: Node, child: Node) void {
        c.YGNodeRemoveChild(self.handle, child.handle);
    }
    pub fn reset(self: Node) void {
        c.YGNodeReset(self.handle);
    }
    pub fn setAlignContent(self: Node, alignContent: enums.Align) void {
        c.YGNodeStyleSetAlignContent(self.handle, @intFromEnum(alignContent));
    }
    pub fn setAlignItems(self: Node, alignItems: enums.Align) void {
        c.YGNodeStyleSetAlignItems(self.handle, @intFromEnum(alignItems));
    }
    pub fn setAlignSelf(self: Node, alignSelf: enums.Align) void {
        c.YGNodeStyleSetAlignSelf(self.handle, @intFromEnum(alignSelf));
    }
    pub fn setAspectRatio(self: Node, aspectRatio: ?f32) void {
        c.YGNodeStyleSetAspectRatio(self.handle, aspectRatio orelse 0.0);
    }
    pub fn setBorder(self: Node, edge: enums.Edge, borderWidth: ?f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetBorder(self.handle, ygEdge, borderWidth orelse 0.0);
    }
    pub fn setDirection(self: Node, direction: enums.Direction) void {
        c.YGNodeStyleSetDirection(self.handle, @intFromEnum(direction));
    }
    pub fn setDisplay(self: Node, display: enums.Display) void {
        c.YGNodeStyleSetDisplay(self.handle, @intFromEnum(display));
    }
    pub fn setFlex(self: Node, flex: ?f32) void {
        c.YGNodeStyleSetFlex(self.handle, flex orelse 0.0);
    }
    pub fn setFlexBasis(self: Node, flexBasis: ?Basis) void {
        if (flexBasis == null) {
            c.YGNodeStyleSetFlexBasis(self.handle, 0);
        } else {
            switch (flexBasis) {
                Basis.number => |value| c.YGNodeStyleSetFlexBasis(self.handle, value),
                Basis.percent => |value| c.YGNodeStyleSetFlexBasisPercent(self.handle, value),
                Basis.auto => c.YGNodeStyleSetFlexBasisAuto(self.handle),
                Basis.fitContent => c.YGNodeStyleSetFlexBasisFitContent(self.handle),
                Basis.maxContent => c.YGNodeStyleSetFlexBasisMaxContent(self.handle),
                Basis.stretch => c.YGNodeStyleSetFlexBasisAuto(self.handle),
            }
        }
    }

    pub fn setFlexBasisPercent(self: Node, percent: f32) void {
        c.YGNodeStyleSetFlexBasisPercent(self.handle, percent);
    }
    pub fn setFlexBasisAuto(self: Node) void {
        c.YGNodeStyleSetFlexBasisAuto(self.handle);
    }
    pub fn setFlexBasisMaxContent(self: Node) void {
        c.YGNodeStyleSetFlexBasisMaxContent(self.handle);
    }
    pub fn setFlexBasisFitContent(self: Node) void {
        c.YGNodeStyleSetFlexBasisFitContent(self.handle);
    }
    pub fn setFlexBasisStretch(self: Node) void {
        c.YGNodeStyleSetFlexBasisStretch(self.handle);
    }
    pub fn setFlexDirection(self: Node, flexDirection: enums.FlexDirection) void {
        c.YGNodeStyleSetFlexDirection(self.handle, @intFromEnum(flexDirection));
    }
    pub fn setFlexGrow(self: Node, flexGrow: f32) void {
        c.YGNodeStyleSetFlexGrow(self.handle, flexGrow);
    }
    pub fn setFlexShrink(self: Node, flexShrink: f32) void {
        c.YGNodeStyleSetFlexShrink(self.handle, flexShrink);
    }
    pub fn setFlexWrap(self: Node, flexWrap: enums.Wrap) void {
        c.YGNodeStyleSetFlexWrap(self.handle, @intFromEnum(flexWrap));
    }

    pub fn setHeight(self: Node, height: f32) void {
        c.YGNodeStyleSetHeight(self.handle, height);
    }
    pub fn setHeightAuto(self: Node) void {
        c.YGNodeStyleSetHeightAuto(self.handle);
    }
    pub fn setHeightPercent(self: Node, percent: f32) void {
        c.YGNodeStyleSetHeightPercent(self.handle, percent);
    }
    pub fn setHeightStretch(self: Node) void {
        c.YGNodeStyleSetHeightStretch(self.handle);
    }

    pub fn setJustifyContent(self: Node, justifyContent: enums.Justify) void {
        c.YGNodeStyleSetJustifyContent(self.handle, @intFromEnum(justifyContent));
    }

    pub fn setGap(self: Node, gutter: enums.Gutter, gapLength: f32) Value {
        c.YGNodeStyleSetGap(self.handle, @intFromEnum(gutter), gapLength);
    }
    pub fn setGapPercent(self: Node, gutter: enums.Gutter, percentage: f32) Value {
        c.YGNodeStyleSetGapPercent(self.handle, @intFromEnum(gutter), percentage);
    }

    pub fn setMargin(self: Node, edge: enums.Edge, margin: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetMargin(self.handle, ygEdge, margin);
    }
    pub fn setMarginAuto(self: Node, edge: enums.Edge) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetMarginAuto(self.handle, ygEdge);
    }
    pub fn setMarginPercent(self: Node, edge: enums.Edge, percent: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetMarginPercent(self.handle, ygEdge, percent);
    }

    pub fn setMaxHeight(self: Node, maxHeight: f32) void {
        c.YGNodeStyleSetMaxHeight(self.handle, maxHeight);
    }
    pub fn setMaxHeightFitContent(self: Node) void {
        c.YGNodeStyleSetMaxHeightFitContent(self.handle);
    }
    pub fn setMaxHeightMaxContent(self: Node) void {
        c.YGNodeStyleSetMaxHeightMaxContent(self.handle);
    }
    pub fn setMaxHeightPercent(self: Node, percent: f32) void {
        c.YGNodeStyleSetMaxHeightPercent(self.handle, percent);
    }
    pub fn setMaxHeightStretch(self: Node) void {
        c.YGNodeStyleSetMaxHeightStretch(self.handle);
    }

    pub fn setMaxWidth(self: Node, maxWidth: f32) void {
        c.YGNodeStyleSetMaxWidth(self.handle, maxWidth);
    }
    pub fn setMaxWidthFitContent(self: Node) void {
        c.YGNodeStyleSetMaxWidthFitContent(self.handle);
    }
    pub fn setMaxWidthMaxContent(self: Node) void {
        c.YGNodeStyleSetMaxWidthMaxContent(self.handle);
    }
    pub fn setMaxWidthPercent(self: Node, percent: f32) void {
        c.YGNodeStyleSetMaxWidthPercent(self.handle, percent);
    }
    pub fn setMaxWidthStretch(self: Node) void {
        c.YGNodeStyleSetMaxWidthStretch(self.handle);
    }

    pub fn setDirtiedFunc(self: Node, func: c.YGDirtiedFunc) void {
        c.YGNodeSetDirtiedFunc(self.handle, func);
    }
    pub fn setMeasureFunc(self: Node, func: c.YGMeasureFunc) void {
        c.YGNodeSetMeasureFunc(self.handle, func);
    }

    pub fn setMinHeight(self: Node, minHeight: f32) void {
        c.YGNodeStyleSetMinHeight(self.handle, minHeight);
    }
    pub fn setMinHeightFitContent(self: Node) void {
        c.YGNodeStyleSetMinHeightFitContent(self.handle);
    }
    pub fn setMinHeightMaxContent(self: Node) void {
        c.YGNodeStyleSetMinHeightMaxContent(self.handle);
    }
    pub fn setMinHeightPercent(self: Node, percent: f32) void {
        c.YGNodeStyleSetMinHeightPercent(self.handle, percent);
    }
    pub fn setMinHeightStretch(self: Node) void {
        c.YGNodeStyleSetMinHeightStretch(self.handle);
    }

    pub fn setMinWidth(self: Node, minWidth: f32) void {
        c.YGNodeStyleSetMinWidth(self.handle, minWidth);
    }
    pub fn setMinWidthFitContent(self: Node) void {
        c.YGNodeStyleSetMinWidthFitContent(self.handle);
    }
    pub fn setMinWidthMaxContent(self: Node) void {
        c.YGNodeStyleSetMinWidthMaxContent(self.handle);
    }
    pub fn setMinWidthPercent(self: Node, percent: f32) void {
        c.YGNodeStyleSetMinWidthPercent(self.handle, percent);
    }
    pub fn setMinWidthStretch(self: Node) void {
        c.YGNodeStyleSetMinWidthStretch(self.handle);
    }

    pub fn setOverflow(self: Node, overflow: enums.Overflow) void {
        c.YGNodeStyleSetOverflow(self.handle, @intFromEnum(overflow));
    }

    pub fn setPadding(self: Node, edge: enums.Edge, padding: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetPadding(self.handle, ygEdge, padding);
    }
    pub fn setPaddingPercent(self: Node, edge: enums.Edge, percent: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetPaddingPercent(self.handle, ygEdge, percent);
    }

    pub fn setPosition(self: Node, edge: enums.Edge, position: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetPosition(self.handle, ygEdge, position);
    }
    pub fn setPositionPercent(self: Node, edge: enums.Edge, percent: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetPositionPercent(self.handle, ygEdge, percent);
    }
    pub fn setPositionType(self: Node, positionType: enums.PositionType) void {
        c.YGNodeStyleSetPositionType(self.handle, @intFromEnum(positionType));
    }
    pub fn setPositionAuto(self: Node, edge: enums.Edge) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        c.YGNodeStyleSetPositionAuto(self.handle, ygEdge);
    }

    pub fn setBoxSizing(self: Node, boxSizing: enums.BoxSizing) void {
        c.YGNodeStyleSetBoxSizing(self.handle, @intFromEnum(boxSizing));
    }

    pub fn setWidth(self: Node, width: f32) void {
        c.YGNodeStyleSetWidth(self.handle, width);
    }
    pub fn setWidthAuto(self: Node) void {
        c.YGNodeStyleSetWidthAuto(self.handle);
    }
    pub fn setWidthFitContent(self: Node) void {
        c.YGNodeStyleSetWidthFitContent(self.handle);
    }
    pub fn setWidthMaxContent(self: Node) void {
        c.YGNodeStyleSetWidthMaxContent(self.handle);
    }
    pub fn setWidthPercent(self: Node, percent: f32) void {
        c.YGNodeStyleSetWidthPercent(self.handle, percent);
    }
    pub fn setWidthStretch(self: Node) void {
        c.YGNodeStyleSetWidthStretch(self.handle);
    }

    pub fn unsetDirtieFunc(self: Node) void {
        c.YGNodeSetDirtiedFunc(self.handle, null);
    }
    pub fn unsetMeasureFunc(self: Node) void {
        c.YGNodeSetMeasureFunc(self.handle, null);
    }

    pub fn setAlwaysFormsContainerBlock(self: Node, always: bool) void {
        c.YGNodeSetAlwaysFormsContainingBlock(self.handle, always);
    }
};

test "basic test" {
    const root = Node.initDefault();
    defer root.free();
    root.setFlexDirection(enums.FlexDirection.Row);
    root.setWidth(100);
    root.setHeight(100);

    const child0 = Node.initDefault();
    defer child0.free();
    child0.setFlexGrow(1);
    child0.setMargin(enums.Edge.Right, 10);
    root.insertChild(child0, 0);

    const child1 = Node.initDefault();
    defer child1.free();
    child1.setFlexGrow(1);
    root.insertChild(child1, 1);

    root.calculateLayout(undefined, undefined, enums.Direction.LTR);
}
