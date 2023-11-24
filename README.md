# randcrack-linear - Linear algebra-based Python random module cracking

The `random` module in Python uses the Mersenne Twister, which has the property that its output bits are linear combinations of the initial state bits. This script generates these linear combinations, which can then be used to recover the internal state of a Mersenne Twister instance given enough information about its outputs.

## Usage
See [test-randcrack.sage](test-randcrack.sage) and [lakectf-solve.sage](lakectf-solve.sage) for examples. The first script recovers the state of the Mersenne Twister from 624 32-bit outputs, and the second script solves the challenge "Choices" from LakeCTF 2023 (in which each character represents 5 bits of output, but the mapping is unknown).

For general usage, the `SymbolicRand` class provides the `genrand_uint32` method, which outputs a list of 32 vectors of dimension 19968 in `GF(2)`. Each vector contains the coefficients of the linear combination of the initial state bits to produce the output bit. The `NumericRand` class is initialized with a vector of dimension 19968 in `GF(2)` representing the initial state, and provides a `predictrand_uint32` method which produces numeric 32-bit values.

Surely this will end all CTF challenges based on breaking the Mersenne Twister...
