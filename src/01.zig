const std = @import("std");

fn toNum(c: []const u8, comptime start: bool) ?u32 {
    const singleDigit = if (start) c[0] else c[c.len - 1];
    if (singleDigit >= '0' and singleDigit <= '9') {
        return singleDigit - '0';
    }
    return null;
}

const numbers = [_][]const u8{
    "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
};

fn toNumParsingWords(c: []const u8, comptime start: bool) ?u32 {
    if (toNum(c, start)) |r| {
        return r;
    }

    for (numbers, 0..numbers.len) |number, i| {
        if (start) {
            if (std.mem.startsWith(u8, c, number)) {
                return @intCast(i);
            }
        } else {
            if (std.mem.endsWith(u8, c, number)) {
                return @intCast(i);
            }
        }
    }

    return null;
}

fn getFirstLastNumber(slice: []const u8, comptime toNumF: fn ([]const u8, comptime bool) ?u32) !struct { u32, u32 } {
    var first: ?u32 = null;
    for (0..slice.len) |i| {
        if (toNumF(slice[i..slice.len], true)) |num| {
            first = num;
            break;
        }
    }
    var last: ?u32 = null;
    var i = slice.len - 1;
    while (i < slice.len) : (i -%= 1) {
        if (toNumF(slice[0 .. i + 1], false)) |num| {
            last = num;
            break;
        }
    }
    if (first == null or last == null) {
        return error.NumberNotFound;
    } else {
        return .{ first.?, last.? };
    }
}

fn day01(input: []const u8, comptime toNumF: fn ([]const u8, comptime bool) ?u32) !u32 {
    var lines = std.mem.split(u8, input, "\n");
    var sum: u32 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        const first, const last = try getFirstLastNumber(line, toNumF);
        sum += first * 10 + last;
    }
    return sum;
}

test "day 01, part 1" {
    const inputTest = @embedFile("inputs/day01_test.txt");
    try std.testing.expectEqual(142, day01(inputTest, toNum));

    const input = @embedFile("inputs/day01.txt");
    try std.testing.expectEqual(55971, day01(input, toNum));

    //try std.testing.expectEqual(1, 0);
}

test "day 01, part 2" {
    const input = @embedFile("inputs/day01.txt");
    try std.testing.expectEqual(54719, day01(input, toNumParsingWords));
}
