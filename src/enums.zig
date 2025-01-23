pub const Align = enum(u16) {
    Auto = 0,
    FlexStart = 1,
    Center = 2,
    FlexEnd = 3,
    Stretch = 4,
    Baseline = 5,
    SpaceBetween = 6,
    SpaceAround = 7,
    SpaceEvenly = 8,
};

pub const BoxSizing = enum(u16) {
    BorderBox = 0,
    ContentBox = 1,
};

pub const Dimension = enum(u16) {
    Width = 0,
    Height = 1,
};

pub const Direction = enum(u16) {
    Inherit = 0,
    LTR = 1,
    RTL = 2,
};

pub const Display = enum(u16) {
    Flex = 0,
    None = 1,
    Contents = 2,
};

pub const Edge = enum(u16) {
    Left = 0,
    Top = 1,
    Right = 2,
    Bottom = 3,
    Start = 4,
    End = 5,
    Horizontal = 6,
    Vertical = 7,
    All = 8,
};

pub const Errata = enum(u16) {
    None = 0,
    StretchFlexBasis = 1,
    AbsolutePositionWithoutInsetsExcludesPadding = 2,
    AbsolutePercentAgainstInnerSize = 4,
    All = 2147483647,
    Classic = 2147483646,
};

pub const ExperimentalFeature = enum(u16) {
    WebFlexBasis = 0,
};

pub const FlexDirection = enum(u16) {
    Column = 0,
    ColumnReverse = 1,
    Row = 2,
    RowReverse = 3,
};

pub const Gutter = enum(u16) {
    Column = 0,
    Row = 1,
    All = 2,
};

pub const Justify = enum(u16) {
    FlexStart = 0,
    Center = 1,
    FlexEnd = 2,
    SpaceBetween = 3,
    SpaceAround = 4,
    SpaceEvenly = 5,
};

pub const LogLevel = enum(u16) {
    Error = 0,
    Warn = 1,
    Info = 2,
    Debug = 3,
    Verbose = 4,
    Fatal = 5,
};

pub const MeasureMode = enum(u16) {
    Undefined = 0,
    Exactly = 1,
    AtMost = 2,
};

pub const NodeType = enum(u16) {
    Default = 0,
    Text = 1,
};

pub const Overflow = enum(u16) {
    Visible = 0,
    Hidden = 1,
    Scroll = 2,
};

pub const PositionType = enum(u16) {
    Static = 0,
    Relative = 1,
    Absolute = 2,
};

pub const Unit = enum(u16) {
    Undefined = 0,
    Point = 1,
    Percent = 2,
    Auto = 3,
    MaxContent = 4,
    FitContent = 5,
    Stretch = 6,
};

pub const Wrap = enum(u16) {
    NoWrap = 0,
    Wrap = 1,
    WrapReverse = 2,
};
