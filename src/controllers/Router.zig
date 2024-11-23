const zap = @import("zap");
const std = @import("std");
const main = @import("../main.zig");
const Server = @import("Server.zig");

const self = @This();

var gpa = std.heap.GeneralPurposeAllocator(.{
    .thread_safe = true
}){};
const allocator = gpa.allocator();
var routers = std.ArrayList(Router).init(allocator);
var endpoints = std.ArrayList(zap.Endpoint).init(allocator);


pub const RequestFn = *const fn (self: *zap.Endpoint, r: zap.Request) void;
pub const Method = struct {
    type: enum { Get, Post, Put, Delete },
    run: RequestFn
};
pub const Router = struct {
    path: []const u8,
    methods: []Method,
};

pub fn register(router: Router) !void {
    try routers.append(router);

    std.debug.print("Registration: {s}\n", .{router.path});
}

pub fn start(server: *Server) !void {
    for (routers.items) |router| {
        for (router.methods) |method| {

            const endpoint = zap.Endpoint.init(.{
                .path = router.path,
                .get = if (method.type == .Get) method.run else null,
                .post = if (method.type == .Post) method.run else null,
                .put = if (method.type == .Put) method.run else null,
                .delete = if (method.type == .Delete) method.run else null,
            });
            const len = endpoints.items.len;
            try endpoints.append(endpoint);
        
        
            try server.register(&endpoints.items[len]);
        }
    }
}