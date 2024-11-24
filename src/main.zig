const std = @import("std");
const zap = @import("zap");
const Home = @import("routers/homepage.zig");
const server = @import("controllers/Server.zig");
const router = @import("controllers/Router.zig");

const port = 3000;
pub fn main() !void {
    var node = server.create(port);
    defer node.deinit();

    try Home.init();
    try router.start(&node);
    try node.listen();

    std.debug.print("Listening on http://0.0.0.0:{d}\n", .{port});

    zap.start(.{
        .threads = 5,
        .workers = 5
    });
}
