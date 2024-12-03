const std = @import("std");

const alloc = std.heap.page_allocator;
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const parse_mul_return_t = struct { sum: ?i32, line: []u8 };

fn parse_mul(line: []u8) parse_mul_return_t {
    var i: usize = 0;
    if (i + 4 > line.len or !std.mem.eql(u8, line[i .. i + 4], "mul(")) {
        return parse_mul_return_t{ .sum = null, .line = line[i + 1 ..] };
    }
    i += 4;
    var first: i32 = 0;
    while (i < line.len and '0' <= line[i] and line[i] <= '9') {
        first = first * 10 + (line[i] - '0');
        i += 1;
    }
    if (i >= line.len or line[i] != ',') {
        return parse_mul_return_t{ .sum = null, .line = line[i + 1 ..] };
    }
    i += 1;
    var second: i32 = 0;
    while (i < line.len and '0' <= line[i] and line[i] <= '9') {
        second = second * 10 + (line[i] - '0');
        i += 1;
    }
    if (i >= line.len or line[i] != ')') {
        return parse_mul_return_t{ .sum = null, .line = line[i + 1 ..] };
    }
    i += 1;
    return parse_mul_return_t{ .sum = first * second, .line = line[i..] };
}

fn read_input_part1() !i32 {
    var sum: i32 = 0;
    while (try stdin.readUntilDelimiterOrEofAlloc(alloc, '\n', 4096)) |line| {
        defer alloc.free(line);
        var currentSlice = line[0..];
        while (currentSlice.len > 0) {
            const parsed_mul = parse_mul(currentSlice);
            currentSlice = parsed_mul.line;
            sum += parsed_mul.sum orelse 0;
        }
    }

    return sum;
}

pub fn part1() !void {
    const answer = try read_input_part1();
    try stdout.print("{d}\n", .{answer});
}

fn read_input_part2() !i32 {
    var sum: i32 = 0;
    var mulCoef: i32 = 1;
    while (try stdin.readUntilDelimiterOrEofAlloc(alloc, '\n', 4096)) |line| {
        defer alloc.free(line);
        var currentSlice = line[0..];
        while (currentSlice.len > 0) {
            const parsed_mul = parse_mul(currentSlice);
            if (parsed_mul.sum) |local_sum| {
                sum += local_sum * mulCoef;
                currentSlice = parsed_mul.line;
                continue;
            }
            if (currentSlice.len >= 4 and std.mem.eql(u8, currentSlice[0..4], "do()")) {
                mulCoef = 1;
                currentSlice = currentSlice[4..];
                continue;
            }
            if (currentSlice.len >= 7 and std.mem.eql(u8, currentSlice[0..7], "don't()")) {
                mulCoef = 0;
                currentSlice = currentSlice[7..];
                continue;
            }
            currentSlice = currentSlice[1..];
        }
    }

    return sum;
}

pub fn part2() !void {
    const answer = try read_input_part2();
    try stdout.print("{d}\n", .{answer});
}
