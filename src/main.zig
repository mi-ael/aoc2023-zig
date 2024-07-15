const std = @import("std");

pub const day01 = @import("day01.zig");

pub fn main() !void {}

test {
    std.testing.refAllDecls(@This());
}
