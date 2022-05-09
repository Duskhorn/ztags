const std = @import("std");

pub fn main() anyerror!void {
    const args = std.process.args();
    for (args.next()) |arg| {
        std.log.debug("{s}", .{arg});
    }
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
