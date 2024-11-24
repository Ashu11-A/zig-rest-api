const std = @import("std");

pub const Self = struct {
    gpa: *std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }),
    allocator: std.mem.Allocator,
};

pub fn create(gpa: *std.heap.GeneralPurposeAllocator(.{ .thread_safe = true })) Self {
    const allocator = gpa.allocator();

    return .{
        .gpa = gpa,
        .allocator = allocator,
    };
}

pub fn detectLeaks(self: Self) void {
    // show potential memory leaks when ZAP is shut down
    const has_leaked = self.gpa.detectLeaks();
    std.log.debug("Has leaked (Main): {}\n", .{has_leaked});
}