const zap = @import("zap");
const std = @import("std");

pub const Self = @This();
listener: zap.Endpoint.Listener = undefined,
alloc: std.mem.Allocator = undefined,

pub fn create (
    alloc : std.mem.Allocator,
    port: usize,
) Self {
    const listener = zap.Endpoint.Listener.init(alloc, .{
                .port = port,
                .log = true,
                .max_clients = 1000,
                .max_body_size = 10 * 1024 * 1024,
                .public_folder = "/public",
                .on_request = on_request,
        });
    return .{
            .alloc = alloc,
            .listener = listener
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

fn on_request(request: zap.Request) void {
    if (request.path) |the_path| {
        std.debug.print("PATH: {s}\n", .{the_path});
    }

    if (request.query) |the_query| {
        std.debug.print("QUERY: {s}\n", .{the_query});
    }
}