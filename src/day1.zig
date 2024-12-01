const std = @import("std");

const alloc = std.heap.page_allocator;
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const input_t = struct { firstList: std.ArrayList(i32), secondList: std.ArrayList(i32) };

fn read_input() !input_t {
    var firstList = std.ArrayList(i32).init(alloc);
    var secondList = std.ArrayList(i32).init(alloc);

    while (try stdin.readUntilDelimiterOrEofAlloc(alloc, '\n', 256)) |line| {
        defer alloc.free(line);
        var it = std.mem.split(u8, line, " ");
        var currentList: i32 = 0;
        while (it.next()) |word| {
            if (word.len > 0) {
                const currentNumber = try std.fmt.parseInt(i32, word, 10);
                if (currentList == 0) {
                    try firstList.append(currentNumber);
                    currentList += 1;
                } else {
                    try secondList.append(currentNumber);
                }
            }
        }
    }

    return input_t{ .firstList = firstList, .secondList = secondList };
}

pub fn part1() !void {
    var input = try read_input();
    const firstList = try input.firstList.toOwnedSlice();
    const secondList = try input.secondList.toOwnedSlice();
    defer input.firstList.deinit();
    defer input.secondList.deinit();

    std.mem.sort(i32, firstList, {}, std.sort.asc(i32));
    std.mem.sort(i32, secondList, {}, std.sort.asc(i32));

    var sum: i32 = 0;

    for (firstList, secondList) |first, second| {
        if (first > second) {
            sum += first - second;
        } else {
            sum += second - first;
        }
    }

    try stdout.print("{d}\n", .{sum});
}

pub fn part2() !void {
    var input = try read_input();
    const firstList = try input.firstList.toOwnedSlice();
    const secondList = try input.secondList.toOwnedSlice();
    defer input.firstList.deinit();
    defer input.secondList.deinit();

    var secondListFrequencyMap = std.AutoHashMap(i32, u32).init(alloc);
    defer secondListFrequencyMap.deinit();

    for (secondList) |value| {
        const currentFreq = secondListFrequencyMap.get(value) orelse 0;
        try secondListFrequencyMap.put(value, currentFreq + 1);
    }

    var sum: i64 = 0;

    for (firstList) |value| {
        const currentFreq = secondListFrequencyMap.get(value) orelse 0;
        sum += @as(i64, value) * @as(i64, currentFreq);
    }

    try stdout.print("{d}\n", .{sum});
}
