const std = @import("std");
const stdout = std.io.getStdOut().writer();


const Base64 = struct{
    _table: *const [64]u8,

    pub fn init() Base64{
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_symb = "0123456789+/";

        return Base64{
            ._table = upper ++ lower ++ numbers_symb,
        };
    }

    fn _calc_encode_length(input: []const u8) !usize{
        if(input.len < 3){
            return 4; //We need to produce enough padding groups. 
        }
        const n_groups: usize = try std.math.divCeil(usize, input.len, 3);

        return n_groups * 4;
    }

    fn _calc_decode_length(input: []const u8) !usize {
        if (input.len < 4) {
            return 3;
        }

        const n_groups: usize = try std.math.divFloor(usize, input.len, 4);
        var multiple_groups: usize = n_groups * 3;
        var i: usize = input.len - 1;
        while (i > 0) : (i -= 1) {
            if (input[i] == '=') {
                multiple_groups -= 1;
            } else {
                break;
            }
        }

        return multiple_groups;
    }

    pub fn _char_at(self:Base64, index: usize) u8{
        return self._table[index];
    }

};

pub fn main() !void {

    const base64 = Base64.init();

    try stdout.print("Characters at index 28: {c}\n", .{base64._char_at(28)});
}
