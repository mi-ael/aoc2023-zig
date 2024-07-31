const std = @import("std");
const expectEqual = std.testing.expectEqual;
const assert = std.debug.assert;

fn idIfPossible(game: Game, id:usize) usize {
    if (game.numBlue <= 14 and game.numRed <= 12 and game.numGreen <= 13) {
        return id;
    }
    return 0;
}

fn power(game:Game, _:usize) usize {
    return @as(usize, game.numBlue) * @as(usize, game.numRed) * @as(usize, game.numGreen);
}

fn day02(input: []const u8, func: fn(Game,usize)usize) !usize {
    var lines = std.mem.split(u8, input, "\n");
    var idSum: usize = 0;
    var id: usize = 1;
    while (lines.next()) |line| {
        defer id += 1;
        if (line.len == 0) {
            continue;
        }
        const game = try Game.fromString(line);
            idSum += func(game, id);
    }
    return idSum;
}

const Game = struct {
    numBlue: u8 = 0,
    numRed: u8 = 0,
    numGreen: u8 = 0,

    pub fn merge(self: *Game, other: Game) void {
        self.numBlue = @max(self.numBlue, other.numBlue);
        self.numRed = @max(self.numRed, other.numRed);
        self.numGreen = @max(self.numGreen, other.numGreen);
    }

    pub fn isPossible(self: Game, other: Game) bool {
        return self.numBlue >= other.numBlue and self.numRed >= other.numRed and self.numGreen >= other.numGreen;
    }

    pub fn fromString(str: []const u8) !Game {
        var game = Game{};
        var parts = std.mem.split(u8, str, ":");
        _ = parts.next().?;
        const sets = parts.next().?;
        assert(parts.next() == null);
        var setsParts = std.mem.split(u8, sets, ";");
        while (setsParts.next()) |set| {
            var moves = std.mem.split(u8, set, ",");
            while (moves.next()) |moveWithSpace| {
                const move = moveWithSpace[1..moveWithSpace.len];
                var moveParts = std.mem.split(u8, move, " ");
                const amount = moveParts.next().?;
                const num = try std.fmt.parseInt(u8, amount, 10);
                const colorStr = moveParts.next().?;
                assert(moveParts.next() == null);
                const color = try Color.fromString(colorStr);
                switch (color) {
                    .Blue => game.numBlue = @max(game.numBlue, num),
                    .Red => game.numRed = @max(game.numRed, num),
                    .Green => game.numGreen = @max(game.numGreen, num),
                }
            }
        }
        return game;
    }
};

const Color = enum {
    Blue,
    Red,
    Green,

    fn fromString(str: []const u8) !Color {
        if (std.mem.eql(u8, str, "blue")) {
            return Color.Blue;
        } else if (std.mem.eql(u8, str, "red")) {
            return Color.Red;
        } else if (std.mem.eql(u8, str, "green")) {
            return Color.Green;
        } else {
            return error.NotAColor;
        }
    }
};

test "day 02, part 1" {
    const inputTest = @embedFile("inputs/day02_test.txt");
    try expectEqual(8, day02(inputTest, idIfPossible));

    const input = @embedFile("inputs/day02.txt");
    try expectEqual(2237, day02(input, idIfPossible));

    //try expectEqual(1, 0);
}

test "day 02, part 2" {
    const input = @embedFile("inputs/day02.txt");
    try expectEqual(66681, day02(input, power));
}
