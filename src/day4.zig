const std = @import("std");

const alloc = std.heap.page_allocator;
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const parse_mul_return_t = struct { sum: ?i32, line: []u8 };

fn read_input() !std.ArrayList([]const u8) {
    var matrix = std.ArrayList([]const u8).init(alloc);

    while (try stdin.readUntilDelimiterOrEofAlloc(alloc, '\n', 256)) |line| {
        try matrix.append(line);
    }

    return matrix;
}

pub fn part1() !void {
    const matrix = (try read_input()).items;
    const XMAS = "XMAS";
    var answer: i32 = 0;
    for (0.., matrix) |i, row| {
        for (0.., row) |j, _| {
            var dx: i32 = -1;
            while (dx < 2) {
                var dy: i32 = -1;
                while (dy < 2) {
                    if (dx == 0 and dy == 0) {
                        dy += 1;
                        continue;
                    }
                    var isXMAS = true;
                    for (0.., XMAS) |k, curr| {
                        const x = @as(i32, @intCast(i)) + dx * @as(i32, @intCast(k));
                        const y = @as(i32, @intCast(j)) + dy * @as(i32, @intCast(k));

                        if (x < 0 or x >= matrix.len or y < 0 or y >= row.len or matrix[@as(usize, @intCast(x))][@as(usize, @intCast(y))] != curr) {
                            isXMAS = false;
                            break;
                        }
                    }
                    if (isXMAS) {
                        answer += 1;
                    }
                    dy += 1;
                }
                dx += 1;
            }
        }
    }
    try stdout.print("{d}\n", .{answer});
}

pub fn part2() !void {
    const matrix = (try read_input()).items;
    var answer: i32 = 0;
    for (0.., matrix) |i, row| {
        for (0.., row) |j, curr| {
            if (curr == 'A' and i > 0 and i + 1 < matrix.len and j > 0 and j + 1 < row.len) {
                if (matrix[i - 1][j - 1] != matrix[i + 1][j + 1] and matrix[i - 1][j + 1] != matrix[i + 1][j - 1]) {
                    if (matrix[i - 1][j - 1] == 'S' or matrix[i - 1][j - 1] == 'M') {
                        if (matrix[i - 1][j + 1] == 'S' or matrix[i - 1][j + 1] == 'M') {
                            if (matrix[i + 1][j - 1] == 'S' or matrix[i + 1][j - 1] == 'M') {
                                if (matrix[i + 1][j + 1] == 'S' or matrix[i + 1][j + 1] == 'M') {
                                    answer += 1;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    try stdout.print("{d}\n", .{answer});
}
