const std = @import("std");
const Yoga = @import("zig-yoga");

pub fn main() !void {
    const root = Yoga.Node.initDefault();
    defer root.free();
    root.setFlexDirection(Yoga.enums.FlexDirection.Row);
    root.setWidth(100);
    root.setHeight(100);

    const child0 = Yoga.Node.initDefault();
    defer child0.free();
    child0.setFlexGrow(1);
    child0.setMargin(Yoga.enums.Edge.Right, 10);
    root.insertChild(child0, 0);

    const child1 = Yoga.Node.initDefault();
    defer child1.free();
    child1.setFlexGrow(1);
    root.insertChild(child1, 1);

    root.calculateLayout(undefined, undefined, Yoga.enums.Direction.LTR);
}
