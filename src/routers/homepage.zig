const std = @import("std");
const zap = @import("zap");
const router = @import("../controllers/Router.zig");

pub const Self = @This();

pub fn init() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{
        .thread_safe = true
    }){};
    var methods = std.ArrayList(router.Method).init(gpa.allocator());

    try methods.append(router.Method{
        .type = .Get,
        .run = get
    });

    try router.register(.{
        .path = "/",
        .methods = methods.items,
    });
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