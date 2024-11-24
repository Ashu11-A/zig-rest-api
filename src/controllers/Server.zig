const zap = @import("zap");
const std = @import("std");
const Heap = @import("Heap.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};
const heap = Heap.create(&gpa);
pub const Self = @This();

listener: zap.Endpoint.Listener = undefined,

pub fn create(
    port: usize,
) Self {
    const listener = zap.Endpoint.Listener.init(heap.allocator, .{
        .port = port,
        .log = true,
        .max_clients = 1000,
        .max_body_size = 10 * 1024 * 1024,
        .public_folder = "/public",
        .on_request = null
    });

    return .{
        // .alloc = alloc,
        .listener = listener,
    };
}

pub fn listen(self: *Self) !void {
    try self.listener.listen();
}

pub fn register(self: *Self, endpoint: *zap.Endpoint) !void {
    try self.listener.register(endpoint);
}

pub fn deinit(self: *Self) void {
    self.listener.deinit();
}
