const std = @import("std");
const zap = @import("zap");
const Home = @import("routers/homepage.zig");
const server = @import("controllers/Server.zig");
const router = @import("controllers/Router.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{
    .thread_safe = true
}){};
pub const allocator = gpa.allocator();

pub fn main() !void {
    {
        var node = server.create(allocator, 3000);

        try Home.init();
        try router.start(&node);
        try node.listen();

        std.debug.print("Listening on http://0.0.0.0:3000\n", .{});

        zap.start(.{
            .threads = 5,
            .workers = 2
        });
    }

    // show potential memory leaks when ZAP is shut down
    // const has_leaked = gpa.detectLeaks();
    // std.log.debug("Has leaked (Main): {}\n", .{has_leaked});
}
