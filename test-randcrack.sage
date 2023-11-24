load("randcrack.sage")

import random, time
try: from tqdm import tqdm
except ImportError: tqdm = lambda it: it

random.seed(time.time())

sym_rand = SymbolicRand()

print("Setting up...")
M = zero_matrix(GF(2), 624*32)
x = []
outputs = []
for i in tqdm(range(624)):
	sym_rel = sym_rand.genrand_uint32()
	for j, rel in enumerate(sym_rel):
		for k in rel.nonzero_positions(): M[32*i + j, k] = 1
	
	output = random.getrandbits(32)
	outputs.append(output)
	x.extend(map(int, bin(output)[2:].zfill(32)))

print("Solving for state...")
state = M.solve_right(vector(GF(2), x))

print("Checking output...")
num_rand = NumericRand(state)
for i in range(624):
	assert num_rand.predictrand_uint32() == outputs[i]

print(f"Prediction: {num_rand.predictrand_uint32()}, got {random.getrandbits(32)}")