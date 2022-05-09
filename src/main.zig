const std = @import("std");

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var alloc = gpa.allocator();
    var args = std.process.args();
    defer args.deinit();

    //ignore executable name
    const executable = try args.next(alloc).?;
    defer alloc.free(executable);

    while (args.next(alloc)) |arg_err| {
        const path = try arg_err;
        std.log.debug("{s}", .{path});
        defer alloc.free(path);

        const source = std.fs.cwd().readFileAllocOptions(alloc, path, std.math.maxInt(usize), null, @alignOf(u8), 0) catch |err| {
            std.log.warn("Error in opening file '{s}' : {}", .{ path, err });
            continue;
        };
        defer alloc.free(source);

        var tree = try std.zig.parse(alloc, source);
        defer tree.deinit(alloc);
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
