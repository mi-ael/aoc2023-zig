const std = @import("std");

pub const day1 = @import("01.zig");

fn get2() !struct { u32, u32 } {
    return .{ 1, 2 };
}

pub fn main() !void {
    const a, const b = try get2();
    std.debug.print("{}, {}\n", .{ a, b });
}

test {
    std.testing.refAllDecls(@This());
}
