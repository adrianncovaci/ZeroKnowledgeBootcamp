from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

// Implement a function that sums even numbers from the provided array
func sum_even{bitwise_ptr: BitwiseBuiltin*}(arr_len: felt, arr: felt*, run: felt, idx: felt) -> (
    sum: felt
) {
    if (arr_len == idx) {
        return (run,);
    }
    let (is_odd) = bitwise_and(arr[idx], 1); 
    if (is_odd == 0) {
        let new_run = run + arr[idx];
        return sum_even(arr_len, arr, new_run, idx + 1);
    }

    return sum_even(arr_len, arr, run, idx + 1);
}
