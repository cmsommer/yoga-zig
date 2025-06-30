pub const yogac = @import("./c_api.zig");
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
    handle: yogac.YGConfigRef,

    pub fn init() Config {
        return .{
            .handle = yogac.YGConfigNew(),
        };
    }

    pub fn free(self: Config) void {
        yogac.YGConfigFree(self);
    }
    pub fn isExperimentalFeatureEnabled(self: Config, feature: enums.ExperimentalFeature) bool {
        return yogac.YGConfigIsExperimentalFeatureEnabled(self.handle, feature);
    }
    pub fn setExperimentalFeatureEnabled(self: Config, feature: enums.ExperimentalFeature, enabled: bool) void {
        yogac.YGConfigSetExperimentalFeatureEnabled(self.handle, feature, enabled);
    }
    pub fn setPointScaleFactor(self: Config, factor: f32) void {
        yogac.YGConfigSetPointScaleFactor(self.handle, factor);
    }
    pub fn getErrata(self: Config) enums.Errata {
        return yogac.YGConfigGetErrata(self.handle);
    }
    pub fn setErrata(self: Config, errata: enums.Errata) void {
        yogac.YGConfigSetErrata(self.handle, errata);
    }
    pub fn getUseWebDefaults(self: Config) bool {
        return yogac.YGConfigGetUseWebDefaults(self);
    }
    pub fn setUseWebDefaults(self: Config, useWebDefaults: bool) void {
        yogac.YGConfigSetUseWebDefaults(self.handle, useWebDefaults);
    }
};

pub const Node = struct {
    handle: yogac.YGNodeRef,

    pub fn new() Node {
        return .{
            .handle = yogac.YGNodeNew(),
        };
    }

    pub fn newWithConfig(config: Config) Node {
        return .{
            .handle = yogac.YGNodeNewWithConfig(config.handle),
        };
    }

    pub fn free(self: Node) void {
        yogac.YGNodeFree(self.handle);
    }
    pub fn freeRecursive(self: Node) void {
        yogac.YGNodeFreeRecursive(self.handle);
    }

    pub fn copyStyle(self: Node) void {
        yogac.YGNodeCopyStyle(self.handle);
    }

    pub fn calculateLayout(self: Node, availableWidth: ?f32, availableHeight: ?f32, ownerDirection: ?enums.Direction) void {
        const ygDir = @as(c_uint, @intFromEnum(ownerDirection orelse enums.Direction.Inherit));
        yogac.YGNodeCalculateLayout(self.handle, availableWidth orelse 0.0, availableHeight orelse 0.0, ygDir);
    }

    pub fn getChildCount(self: Node) usize {
        return yogac.YGNodeGetChildCount(self.handle);
    }
    pub fn getChild(self: Node, index: usize) Node {
        const ygNode = yogac.YGNodeGetChild(self.handle, index);
        return .{ .handle = ygNode };
    }

    pub fn getFlexDirection(self: Node) enums.FlexDirection {
        const ygValue = yogac.YGNodeStyleGetFlexDirection(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }

    pub fn getWidth(self: Node) Value {
        const ygValue = yogac.YGNodeStyleGetWidth(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }

    pub fn getHeight(self: Node) Value {
        const ygValue = yogac.YGNodeStyleGetHeight(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn insertChild(self: Node, child: Node, index: usize) void {
        yogac.YGNodeInsertChild(self.handle, child.handle, index);
    }

    pub fn getComputedBorder(self: Node, edge: enums.Edge) f32 {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        return yogac.YGNodeLayoutGetBorder(self.handle, ygEdge);
    }
    pub fn getComputedLayout(self: Node) Layout {
        const left = yogac.YGNodeLayoutGetLeft(self.handle);
        const right = yogac.YGNodeLayoutGetRight(self.handle);
        const top = yogac.YGNodeLayoutGetTop(self.handle);
        const bottom = yogac.YGNodeLayoutGetBottom(self.handle);
        const width = yogac.YGNodeLayoutGetWidth(self.handle);
        const height = yogac.YGNodeLayoutGetHeight(self.handle);

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
        return yogac.YGNodeLayoutGetMargin(self.handle, ygEdge);
    }
    pub fn getComputedPadding(self: Node, edge: enums.Edge) f32 {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        return yogac.YGNodeLayoutGetPadding(self.handle, ygEdge);
    }
    pub fn getComputedWidth(self: Node) f32 {
        return yogac.YGNodeLayoutGetWidth(self.handle);
    }
    pub fn getComputedHeight(self: Node) f32 {
        return yogac.YGNodeLayoutGetWidth(self.handle);
    }
    pub fn getComputedLeft(self: Node) f32 {
        return yogac.YGNodeLayoutGetLeft(self.handle);
    }
    pub fn getComputedTop(self: Node) f32 {
        return yogac.YGNodeLayoutGetTop(self.handle);
    }
    pub fn getComputedRight(self: Node) f32 {
        return yogac.YGNodeLayoutGetRight(self.handle);
    }
    pub fn getComputedBottom(self: Node) f32 {
        return yogac.YGNodeLayoutGetBottom(self.handle);
    }

    pub fn getAlignContent(self: Node) enums.Align {
        const ygValue = yogac.YGNodeStyleGetAlignContent(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getAlignItems(self: Node) enums.Align {
        const ygValue = yogac.YGNodeStyleGetAlignItems(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getAlignSelf(self: Node) enums.Align {
        const ygValue = yogac.YGNodeStyleGetAlignSelf(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getAspectRatio(self: Node) f32 {
        return yogac.YGNodeStyleGetAspectRatio(self.handle);
    }
    pub fn getBorder(self: Node, edge: enums.Edge) f32 {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        return yogac.YGNodeStyleGetBorder(self.handle, ygEdge);
    }

    pub fn getDirection(self: Node) enums.Direction {
        const ygValue = yogac.YGNodeStyleGetDirection(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getDisplay(self: Node) enums.Display {
        const ygValue = yogac.YGNodeStyleGetDisplay(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getFlexBasis(self: Node) Value {
        const ygValue = yogac.YGNodeStyleGetFlexBasis(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }

    pub fn getFlexGrow(self: Node) f32 {
        return yogac.YGNodeStyleGetFlexGrow(self.handle);
    }
    pub fn getFlexShrink(self: Node) f32 {
        return yogac.YGNodeStyleGetFlexShrink(self.handle);
    }
    pub fn getFlexWrap(self: Node) enums.Wrap {
        const ygValue = yogac.YGNodeStyleGetFlexWrap(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }

    pub fn getJustifyContent(self: Node) enums.Justify {
        const ygValue = yogac.YGNodeStyleGetJustifyContent(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }

    pub fn getGap(self: Node, gutter: enums.Gutter) Value {
        const ygValue = yogac.YGNodeStyleGetGap(self.handle, @intFromEnum(gutter));
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMargin(self: Node, edge: enums.Edge) Value {
        const ygValue = yogac.YGNodeStyleGetMargin(self.handle, @intFromEnum(edge));
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMaxHeight(self: Node) Value {
        const ygValue = yogac.YGNodeStyleGetMaxHeight(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMaxWidth(self: Node) Value {
        const ygValue = yogac.YGNodeStyleGetMaxWidth(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMinHeight(self: Node) Value {
        const ygValue = yogac.YGNodeStyleGetMinHeight(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getMinWidth(self: Node) Value {
        const ygValue = yogac.YGNodeStyleGetMinWidth(self.handle);
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getOverflow(self: Node) enums.Overflow {
        const ygValue = yogac.YGNodeStyleGetOverflow(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getPadding(self: Node, edge: enums.Edge) Value {
        const ygValue = yogac.YGNodeStyleGetPadding(self.handle, @intFromEnum(edge));
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getParent(self: Node) ?Node {
        const ygNode = yogac.YGNodeGetParent(self.handle);
        if (ygNode == null) {
            return null;
        }
        return .{ .handle = ygNode };
    }
    pub fn getPosition(self: Node, edge: enums.Edge) Value {
        const ygValue = yogac.YGNodeStyleGetPosition(self.handle, @intFromEnum(edge));
        return .{
            .value = ygValue.value,
            .unit = @enumFromInt(@as(i32, ygValue.unit)),
        };
    }
    pub fn getPositionType(self: Node) enums.PositionType {
        const ygValue = yogac.YGNodeStyleGetPositionType(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn getBoxSizing(self: Node) enums.BoxSizing {
        const ygValue = yogac.YGNodeStyleGetBoxSizing(self.handle);
        return @enumFromInt(@as(i32, ygValue));
    }
    pub fn isDirty(self: Node) bool {
        return yogac.YGNodeIsDirty(self.handle);
    }
    pub fn isReferenceBaseline(self: Node) bool {
        return yogac.YGNodeIsReferenceBaseline(self.handle);
    }
    pub fn markDirty(self: Node) void {
        yogac.YGNodeMarkDirty(self.handle);
    }
    pub fn hasNewLayout(self: Node) bool {
        return yogac.YGNodeHasNewLayout(self.handle);
    }
    pub fn markLayoutSeen(self: Node) void {
        yogac.YGNodeMarkLayoutSeen(self.handle);
    }
    pub fn removeChild(self: Node, child: Node) void {
        yogac.YGNodeRemoveChild(self.handle, child.handle);
    }
    pub fn reset(self: Node) void {
        yogac.YGNodeReset(self.handle);
    }
    pub fn setAlignContent(self: Node, alignContent: enums.Align) void {
        yogac.YGNodeStyleSetAlignContent(self.handle, @intFromEnum(alignContent));
    }
    pub fn setAlignItems(self: Node, alignItems: enums.Align) void {
        yogac.YGNodeStyleSetAlignItems(self.handle, @intFromEnum(alignItems));
    }
    pub fn setAlignSelf(self: Node, alignSelf: enums.Align) void {
        yogac.YGNodeStyleSetAlignSelf(self.handle, @intFromEnum(alignSelf));
    }
    pub fn setAspectRatio(self: Node, aspectRatio: ?f32) void {
        yogac.YGNodeStyleSetAspectRatio(self.handle, aspectRatio orelse 0.0);
    }
    pub fn setBorder(self: Node, edge: enums.Edge, borderWidth: ?f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        yogac.YGNodeStyleSetBorder(self.handle, ygEdge, borderWidth orelse 0.0);
    }
    pub fn setDirection(self: Node, direction: enums.Direction) void {
        yogac.YGNodeStyleSetDirection(self.handle, @intFromEnum(direction));
    }
    pub fn setDisplay(self: Node, display: enums.Display) void {
        yogac.YGNodeStyleSetDisplay(self.handle, @intFromEnum(display));
    }
    pub fn setFlex(self: Node, flex: ?f32) void {
        yogac.YGNodeStyleSetFlex(self.handle, flex orelse 0.0);
    }
    pub fn setFlexBasis(self: Node, flexBasis: ?Basis) void {
        if (flexBasis == null) {
            yogac.YGNodeStyleSetFlexBasis(self.handle, 0);
        } else {
            switch (flexBasis) {
                Basis.number => |value| yogac.YGNodeStyleSetFlexBasis(self.handle, value),
                Basis.percent => |value| yogac.YGNodeStyleSetFlexBasisPercent(self.handle, value),
                Basis.auto => yogac.YGNodeStyleSetFlexBasisAuto(self.handle),
                Basis.fitContent => yogac.YGNodeStyleSetFlexBasisFitContent(self.handle),
                Basis.maxContent => yogac.YGNodeStyleSetFlexBasisMaxContent(self.handle),
                Basis.stretch => yogac.YGNodeStyleSetFlexBasisAuto(self.handle),
            }
        }
    }

    pub fn setFlexBasisPercent(self: Node, percent: f32) void {
        yogac.YGNodeStyleSetFlexBasisPercent(self.handle, percent);
    }
    pub fn setFlexBasisAuto(self: Node) void {
        yogac.YGNodeStyleSetFlexBasisAuto(self.handle);
    }
    pub fn setFlexBasisMaxContent(self: Node) void {
        yogac.YGNodeStyleSetFlexBasisMaxContent(self.handle);
    }
    pub fn setFlexBasisFitContent(self: Node) void {
        yogac.YGNodeStyleSetFlexBasisFitContent(self.handle);
    }
    pub fn setFlexBasisStretch(self: Node) void {
        yogac.YGNodeStyleSetFlexBasisStretch(self.handle);
    }
    pub fn setFlexDirection(self: Node, flexDirection: enums.FlexDirection) void {
        yogac.YGNodeStyleSetFlexDirection(self.handle, @intFromEnum(flexDirection));
    }
    pub fn setFlexGrow(self: Node, flexGrow: f32) void {
        yogac.YGNodeStyleSetFlexGrow(self.handle, flexGrow);
    }
    pub fn setFlexShrink(self: Node, flexShrink: f32) void {
        yogac.YGNodeStyleSetFlexShrink(self.handle, flexShrink);
    }
    pub fn setFlexWrap(self: Node, flexWrap: enums.Wrap) void {
        yogac.YGNodeStyleSetFlexWrap(self.handle, @intFromEnum(flexWrap));
    }

    pub fn setHeight(self: Node, height: f32) void {
        yogac.YGNodeStyleSetHeight(self.handle, height);
    }
    pub fn setHeightAuto(self: Node) void {
        yogac.YGNodeStyleSetHeightAuto(self.handle);
    }
    pub fn setHeightPercent(self: Node, percent: f32) void {
        yogac.YGNodeStyleSetHeightPercent(self.handle, percent);
    }
    pub fn setHeightStretch(self: Node) void {
        yogac.YGNodeStyleSetHeightStretch(self.handle);
    }

    pub fn setJustifyContent(self: Node, justifyContent: enums.Justify) void {
        yogac.YGNodeStyleSetJustifyContent(self.handle, @intFromEnum(justifyContent));
    }

    pub fn setGap(self: Node, gutter: enums.Gutter, gapLength: f32) void {
        yogac.YGNodeStyleSetGap(self.handle, @intFromEnum(gutter), gapLength);
    }
    pub fn setGapPercent(self: Node, gutter: enums.Gutter, percentage: f32) void {
        yogac.YGNodeStyleSetGapPercent(self.handle, @intFromEnum(gutter), percentage);
    }

    pub fn setMargin(self: Node, edge: enums.Edge, margin: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        yogac.YGNodeStyleSetMargin(self.handle, ygEdge, margin);
    }
    pub fn setMarginAuto(self: Node, edge: enums.Edge) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        yogac.YGNodeStyleSetMarginAuto(self.handle, ygEdge);
    }
    pub fn setMarginPercent(self: Node, edge: enums.Edge, percent: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        yogac.YGNodeStyleSetMarginPercent(self.handle, ygEdge, percent);
    }

    pub fn setMaxHeight(self: Node, maxHeight: f32) void {
        yogac.YGNodeStyleSetMaxHeight(self.handle, maxHeight);
    }
    pub fn setMaxHeightFitContent(self: Node) void {
        yogac.YGNodeStyleSetMaxHeightFitContent(self.handle);
    }
    pub fn setMaxHeightMaxContent(self: Node) void {
        yogac.YGNodeStyleSetMaxHeightMaxContent(self.handle);
    }
    pub fn setMaxHeightPercent(self: Node, percent: f32) void {
        yogac.YGNodeStyleSetMaxHeightPercent(self.handle, percent);
    }
    pub fn setMaxHeightStretch(self: Node) void {
        yogac.YGNodeStyleSetMaxHeightStretch(self.handle);
    }

    pub fn setMaxWidth(self: Node, maxWidth: f32) void {
        yogac.YGNodeStyleSetMaxWidth(self.handle, maxWidth);
    }
    pub fn setMaxWidthFitContent(self: Node) void {
        yogac.YGNodeStyleSetMaxWidthFitContent(self.handle);
    }
    pub fn setMaxWidthMaxContent(self: Node) void {
        yogac.YGNodeStyleSetMaxWidthMaxContent(self.handle);
    }
    pub fn setMaxWidthPercent(self: Node, percent: f32) void {
        yogac.YGNodeStyleSetMaxWidthPercent(self.handle, percent);
    }
    pub fn setMaxWidthStretch(self: Node) void {
        yogac.YGNodeStyleSetMaxWidthStretch(self.handle);
    }

    pub fn setDirtiedFunc(self: Node, func: yogac.YGDirtiedFunc) void {
        yogac.YGNodeSetDirtiedFunc(self.handle, func);
    }
    pub fn setMeasureFunc(self: Node, func: yogac.YGMeasureFunc) void {
        yogac.YGNodeSetMeasureFunc(self.handle, func);
    }

    pub fn setMinHeight(self: Node, minHeight: f32) void {
        yogac.YGNodeStyleSetMinHeight(self.handle, minHeight);
    }
    pub fn setMinHeightFitContent(self: Node) void {
        yogac.YGNodeStyleSetMinHeightFitContent(self.handle);
    }
    pub fn setMinHeightMaxContent(self: Node) void {
        yogac.YGNodeStyleSetMinHeightMaxContent(self.handle);
    }
    pub fn setMinHeightPercent(self: Node, percent: f32) void {
        yogac.YGNodeStyleSetMinHeightPercent(self.handle, percent);
    }
    pub fn setMinHeightStretch(self: Node) void {
        yogac.YGNodeStyleSetMinHeightStretch(self.handle);
    }

    pub fn setMinWidth(self: Node, minWidth: f32) void {
        yogac.YGNodeStyleSetMinWidth(self.handle, minWidth);
    }
    pub fn setMinWidthFitContent(self: Node) void {
        yogac.YGNodeStyleSetMinWidthFitContent(self.handle);
    }
    pub fn setMinWidthMaxContent(self: Node) void {
        yogac.YGNodeStyleSetMinWidthMaxContent(self.handle);
    }
    pub fn setMinWidthPercent(self: Node, percent: f32) void {
        yogac.YGNodeStyleSetMinWidthPercent(self.handle, percent);
    }
    pub fn setMinWidthStretch(self: Node) void {
        yogac.YGNodeStyleSetMinWidthStretch(self.handle);
    }

    pub fn setOverflow(self: Node, overflow: enums.Overflow) void {
        yogac.YGNodeStyleSetOverflow(self.handle, @intFromEnum(overflow));
    }

    pub fn setPadding(self: Node, edge: enums.Edge, padding: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        yogac.YGNodeStyleSetPadding(self.handle, ygEdge, padding);
    }
    pub fn setPaddingPercent(self: Node, edge: enums.Edge, percent: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        yogac.YGNodeStyleSetPaddingPercent(self.handle, ygEdge, percent);
    }

    pub fn setPosition(self: Node, edge: enums.Edge, position: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        yogac.YGNodeStyleSetPosition(self.handle, ygEdge, position);
    }
    pub fn setPositionPercent(self: Node, edge: enums.Edge, percent: f32) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        yogac.YGNodeStyleSetPositionPercent(self.handle, ygEdge, percent);
    }
    pub fn setPositionType(self: Node, positionType: enums.PositionType) void {
        yogac.YGNodeStyleSetPositionType(self.handle, @intFromEnum(positionType));
    }
    pub fn setPositionAuto(self: Node, edge: enums.Edge) void {
        const ygEdge = @as(c_uint, @intFromEnum(edge));
        yogac.YGNodeStyleSetPositionAuto(self.handle, ygEdge);
    }

    pub fn setBoxSizing(self: Node, boxSizing: enums.BoxSizing) void {
        yogac.YGNodeStyleSetBoxSizing(self.handle, @intFromEnum(boxSizing));
    }

    pub fn setWidth(self: Node, width: f32) void {
        yogac.YGNodeStyleSetWidth(self.handle, width);
    }
    pub fn setWidthAuto(self: Node) void {
        yogac.YGNodeStyleSetWidthAuto(self.handle);
    }
    pub fn setWidthFitContent(self: Node) void {
        yogac.YGNodeStyleSetWidthFitContent(self.handle);
    }
    pub fn setWidthMaxContent(self: Node) void {
        yogac.YGNodeStyleSetWidthMaxContent(self.handle);
    }
    pub fn setWidthPercent(self: Node, percent: f32) void {
        yogac.YGNodeStyleSetWidthPercent(self.handle, percent);
    }
    pub fn setWidthStretch(self: Node) void {
        yogac.YGNodeStyleSetWidthStretch(self.handle);
    }

    pub fn unsetDirtieFunc(self: Node) void {
        yogac.YGNodeSetDirtiedFunc(self.handle, null);
    }
    pub fn unsetMeasureFunc(self: Node) void {
        yogac.YGNodeSetMeasureFunc(self.handle, null);
    }

    pub fn setAlwaysFormsContainerBlock(self: Node, always: bool) void {
        yogac.YGNodeSetAlwaysFormsContainingBlock(self.handle, always);
    }
};

test "basic test" {
    const root = Node.new();
    defer root.free();
    root.setFlexDirection(enums.FlexDirection.Row);
    root.setWidth(100);
    root.setHeight(100);

    const child0 = Node.new();
    defer child0.free();
    child0.setFlexGrow(1);
    child0.setMargin(enums.Edge.Right, 10);
    root.insertChild(child0, 0);

    const child1 = Node.new();
    defer child1.free();
    child1.setFlexGrow(1);
    root.insertChild(child1, 1);

    root.calculateLayout(undefined, undefined, enums.Direction.LTR);
}
