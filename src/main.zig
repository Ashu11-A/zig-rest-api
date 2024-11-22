const std = @import("std");
const zap = @import("zap");
const Home = @import("routers/homepage.zig");

fn on_request(request: zap.Request) void {
    if (request.path) |the_path| {
        std.debug.print("PATH: {s}\n", .{the_path});
    }

    if (request.query) |the_query| {
        std.debug.print("QUERY: {s}\n", .{the_query});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{
        .thread_safe = true,
    }){};
    const allocator = gpa.allocator();

    {
        var listener = zap.Endpoint.Listener.init(allocator, .{
            .port = 3000,
            .log = true,
            .max_clients = 1000,
            .max_body_size = 10 * 1024 * 1024,
            .public_folder = "/public",
            .on_request = on_request,
        });
        defer listener.deinit();

        var userWeb = Home.init(allocator);
        try listener.register(userWeb.endpoint());

        try listener.listen();

        std.debug.print("Listening on http://0.0.0.0:3000\n", .{});

        zap.start(.{
            .threads = 5,
            .workers = 2
        });
    }

    const hasLeaked = gpa.detectLeaks();
    std.log.debug("Has leaked: {}\n", .{hasLeaked});
}
