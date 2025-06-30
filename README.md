# Yoga-zig

A zig port of the yoga library.
This library has a simple integration of the cpp library with zig function that call the source directly.
The cpp function can be gotten directly by using the yogac import.

# Example

```zig
const zyoga = @import('yoga-zig')
const Node = zyoga.Node;
const Direction = zyoga.enums.Direction;
const FlexDirection = zyoga.enums.FlexDirection;
const Edge = zyoga.enums.Edge;

const root = Node.new();
defer root.free();

root.setFlexDirection(FlexDirection.Row);
root.setWidth(100);
root.setHeight(100);

const child0 = Node.new();
defer child0.free();

child0.setFlexGrow(1);
child0.setMargin(Edge.Right, 10);

root.insertChild(child0, 0);

const child1 = Node.new();
defer child1.free();

child1.setFlexGrow(1);

root.insertChild(child1, 1);

root.calculateLayout(undefined, undefined, Direction.LTR);
```