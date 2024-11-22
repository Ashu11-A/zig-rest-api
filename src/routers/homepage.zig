const std = @import("std");
const zap = @import("zap");

alloc: std.mem.Allocator = undefined,
ep: zap.Endpoint = undefined,

pub const Self = @This();

pub fn init(
    a: std.mem.Allocator
) Self {
    return .{
        .alloc = a,
        .ep = zap.Endpoint.init(.{
            .path = "/",
            .get = get,
        })
    };
}

pub fn endpoint(self: *Self) *zap.Endpoint {
    return &self.ep;
}

fn get (e: *zap.Endpoint, request: zap.Request) void {
    // const self: * Self = @fieldParentPtr("ep", e);
    
    if (request.path) |path| {
        if (path.len == e.settings.path.len) {
            var jsonbuf: [256]u8 = undefined;

            if (zap.stringifyBuf(&jsonbuf, .{ .hello = "World" }, .{})) |json| {
                request.sendJson(json) catch return;
            }
        }
    }
}