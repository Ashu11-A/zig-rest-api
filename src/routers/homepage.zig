const std = @import("std");
const zap = @import("zap");
const router = @import("../controllers/Router.zig");
const Heap = @import("../controllers/Heap.zig");

pub const Self = @This();
var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = true }){};

pub fn init() !void {
    const heap = Heap.create(&gpa);
    var methods = std.ArrayList(router.Method).init(heap.allocator);

    try methods.append(router.Method{ .type = .Get, .run = get });
    try router.register(.{
        .path = "/",
        .methods = methods.items,
    });
}

fn get(e: *zap.Endpoint, request: zap.Request) void {
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
