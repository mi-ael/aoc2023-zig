const std = @import("std");

pub const day1 = @import("01.zig");

pub fn main() !void {}

test {
    std.testing.refAllDecls(@This());
}
