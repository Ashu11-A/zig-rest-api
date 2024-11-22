const std = @import("std");

fn display (comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt, args);
}

pub fn main() void {
    display("Hello, {s}!\n", .{"World"});

    const number: i8 = 5;
    display("{d}", .{number});

    display("\nFor:\n", .{});
    const array = [6]i8{ 1, 2, 3, 4, 5, 6 };
    for (0.., array) |index, element| {
        display("({d}) Number: {d}\n", .{index, element});
    }

    display("\nWhile:\n", .{});
    var index: u8 = 0;
    while (index < array.len) {
        defer index += 1;

        if (index >= (array.len / 2)) break;
        display("({d}) Number: {d}\n", .{index, array[index]});
    }

    display("\nSwitch:\n", .{});
    const elements = [_]i8{ 18, 19 };

    for (elements) |element| {
        switch (element) {
            0...18 => {
                display("Numero: {d}\n", .{element});
            },
            else => {
                display("Valor fora do intervalo: {d}\n", .{element});
            }
        }
    }
}