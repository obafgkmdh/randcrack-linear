load("randcrack.sage")

try: from tqdm import tqdm
except ImportError: tqdm = lambda it: it

with open("lakectf-challenge-input.txt") as f:
	chars = f.read().strip()

mapping = {}

nchars = len(chars)
nrows = (nchars - 32) * 5
rels = zero_matrix(GF(2), nrows, 624*32)

sym_rand = SymbolicRand()

i = 0
for c in tqdm(chars[:nchars]):
	a = sym_rand.genrand_uint32()
	b = sym_rand.genrand_uint32()
	if c not in mapping:
		mapping[c] = a[:5]
	else:
		for ind in range(5):
			for j in (a[ind] - mapping[c][ind]).nonzero_positions():
				rels[i, j] = 1
			i += 1

print("calculating kernel")
kern = rels.right_kernel_matrix()

print("testing solutions")
for row in kern.rows():	
	num_rand = NumericRand(row)
	
	flag = [' '] * 32
	try:
		for c in chars:
			a = num_rand.predictrand_uint32()
			b = num_rand.predictrand_uint32()
			index = a >> 27
			if flag[index] == ' ':
				flag[index] = c
			else:
				assert flag[index] == c
	except AssertionError: continue
	
	flag = ''.join(flag)
	print(f"EPFL{{{flag}}}")
