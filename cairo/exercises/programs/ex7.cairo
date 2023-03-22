%lang starknet
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem

// Using binary operations return:
// - 1 when pattern of bits is 01010101 from LSB up to MSB 1, but accounts for trailing zeros
// - 0 otherwise

// 000000101010101 PASS
// 010101010101011 FAIL

func pattern{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(
    n: felt, idx: felt, exp: felt, broken_chain: felt
) -> (true: felt) {
    alloc_locals;
    if (broken_chain == 1) {
        return (0,);
    }

    if (n == 0) {
        return (1,);
    }

    let (is_odd) = bitwise_and(n, 1);
    let (opposite) = bitwise_xor(is_odd, 1);
    let (right_shift, _) = unsigned_div_rem(n, 2);

    if (idx == 0 and is_odd == 0) {
        return pattern(right_shift, idx, exp, broken_chain);
    }
    if (idx == 0 and is_odd == 1) {
        return pattern(right_shift, idx + 1, exp, broken_chain);
    }


    if (is_odd == exp) {
        return pattern(right_shift, idx + 1, opposite, 0);
    } else {
        return pattern(0, 0, 0, 1);
    }
}
