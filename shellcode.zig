// test.c: 

    // int foo() {
    //   return 10;
    // }

// gcc -c test.c 

// objdump test.o -d

// test.o:     file format elf64-littleaarch64
// Disassembly of section .text:
// 0000000000000000 <foo>:
//   0:	52800140 	mov	w0, #0xa                   	// #10
//   4:	d65f03c0 	ret

// zig run shellcode.zig

const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const shellcode = "\x40\x01\x80\x52\xc0\x03\x5f\xd6";
    var result: i32 = 0;

    const buffer = try allocator.alloc(u8, shellcode.len);
    defer allocator.free(buffer);

    @memcpy(buffer, shellcode);
     _ = std.os.linux.mprotect(buffer.ptr, shellcode.len, 7);

    const shellcode_ptr: *fn() callconv(.C) c_int = @alignCast(@ptrCast(buffer.ptr));
    result = shellcode_ptr();

    std.debug.print("{d}\n", .{result});
}
