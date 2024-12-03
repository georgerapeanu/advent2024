const std = @import("std");

const alloc = std.heap.page_allocator;
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

fn read_input() !std.ArrayList(std.ArrayList(i32)) {
    var matrix = std.ArrayList(std.ArrayList(i32)).init(alloc);

    while (try stdin.readUntilDelimiterOrEofAlloc(alloc, '\n', 256)) |line| {
        defer alloc.free(line);
        var it = std.mem.split(u8, line, " ");
        var currentList = std.ArrayList(i32).init(alloc);
        while (it.next()) |word| {
            if (word.len > 0) {
                const currentNumber = try std.fmt.parseInt(i32, word, 10);
                try currentList.append(currentNumber);
            }
        }
        try matrix.append(currentList);
    }

    return matrix;
}

fn is_safe(report: std.ArrayList(i32)) bool {
    const items = report.items;
    var allIncreasing = true;
    var allDecreasing = true;
    var diffOk = true;
    for (0.., items) |i, _| {
        if (i == 0) continue;
        allIncreasing = allIncreasing and (items[i] > items[i - 1]);
        allDecreasing = allDecreasing and (items[i] < items[i - 1]);
        var diff = items[i] - items[i - 1];
        if (diff < 0) {
            diff *= -1;
        }
        diffOk = diffOk and (1 <= diff and diff <= 3);
    }

    return (allIncreasing or allDecreasing) and diffOk;
}

fn dampner_is_safe(report: std.ArrayList(i32)) !bool {
    for (0.., report.items) |i, _| {
        var currentReport = std.ArrayList(i32).init(alloc);
        defer currentReport.deinit();

        for (0.., report.items) |j, item| {
            if (i != j) {
                try currentReport.append(item);
            }
        }
        if (is_safe(currentReport)) {
            return true;
        }
    }
    return false;
}

pub fn part1() !void {
    var matrix = try read_input();
    defer {
        for (matrix.items) |row| {
            row.deinit();
        }
        matrix.deinit();
    }

    var count: i32 = 0;
    for (matrix.items) |row| {
        if (is_safe(row)) {
            count += 1;
        }
    }

    try stdout.print("{d}\n", .{count});
}

pub fn part2() !void {
    var matrix = try read_input();
    defer {
        for (matrix.items) |row| {
            row.deinit();
        }
        matrix.deinit();
    }

    var count: i32 = 0;
    for (matrix.items) |row| {
        if (try dampner_is_safe(row)) {
            count += 1;
        }
    }

    try stdout.print("{d}\n", .{count});
}
