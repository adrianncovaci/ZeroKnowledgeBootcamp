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
    if (idx == 8) {
        let (is_odd) = bitwise_and(n, 1);
        if (is_odd == 1) {
            return (1,);
        }
        return (0,);
    }
    let (local is_odd) = bitwise_and(n, 1);
    if (is_odd == 1 and exp == 0) {
        let (right_shift, _) = unsigned_div_rem(n, 2);
        let (right_odd) = bitwise_and(right_shift, 1);
        return pattern(right_shift, idx + 1, right_odd, 0);
    }

    if (is_odd == 0 and exp == 1) {
        let (right_shift, _) = unsigned_div_rem(n, 2);
        let (right_odd) = bitwise_and(right_shift, 1);
        return pattern(right_shift, idx + 1, right_odd, 0);
    }

    if (is_odd == 0 and exp == 0 and idx == 0) {
        let (right_shift, _) = unsigned_div_rem(n, 2);
        let (right_odd) = bitwise_and(right_shift, 1);
        return pattern(right_shift, idx, right_odd, 0);
    }

    return pattern(n, idx, 0, 1);
}
