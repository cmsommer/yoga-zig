const yoga = @import("yoga-zig");

pub fn main() !void {
    const root = yoga.Node.initDefault();
    defer root.free();
    root.setFlexDirection(yoga.enums.FlexDirection.Row);
    root.setWidth(100);
    root.setHeight(100);

    const child0 = yoga.Node.initDefault();
    defer child0.free();
    child0.setFlexGrow(1);
    child0.setMargin(yoga.enums.Edge.Right, 10);
    root.insertChild(child0, 0);

    const child1 = yoga.Node.initDefault();
    defer child1.free();
    child1.setFlexGrow(1);
    root.insertChild(child1, 1);

    root.calculateLayout(undefined, undefined, yoga.enums.Direction.LTR);
}
