from pathlib import Path
import numpy as np
import random

Path("./testbench").mkdir(parents=True, exist_ok=True)

data = []
ans = []
instructions = []
WIDTH_BIT = 3
INDEX_BIT = 5
PADDING = '0' * (29 - 3 * INDEX_BIT)

row_size = 3
col_size = 4
data_size = pow(2, INDEX_BIT-1)
instr_size = pow(2, INDEX_BIT-1)

encode = lambda index, length=INDEX_BIT: ''.join([str((index >> i) & 1) for i in range(length - 1, -1, -1)])
genData = lambda row, col, bound=(-10, 10): np.random.randint(bound[0], bound[1], size=(row, col), dtype=np.int)

'''
a, b stand for index in list/data memory
dest stand for index of the output location in the list/data memory
if constant == 0, then output = operate on mem[a] and mem[b], otherwise operate on mem[a] and constant
'''
def add(a: int, b: int, dest:int, constant: int = 0) -> np.ndarray:
    instructions.append(f'000{encode(a)}{encode(b)}{encode(dest)}{encode(constant, 29 - 3 * INDEX_BIT)}')
    return data[a] + data[b]

def sub(a: int, b: int, dest:int, constant: int = 0) -> np.ndarray:
    instructions.append(f'001{encode(a)}{encode(b)}{encode(dest)}{encode(constant, 29 - 3 * INDEX_BIT)}')
    return data[a] - data[b]

def mul(a: int, b: int, dest:int, constant: int = 0) -> np.ndarray:
    instructions.append(f'010{encode(a)}{encode(b)}{encode(dest)}{encode(constant, 29 - 3 * INDEX_BIT)}')
    return data[a] * data[b]

def div(a: int, b: int, dest:int, constant: int = 0) -> np.ndarray:
    instructions.append(f'011{encode(a)}{encode(b)}{encode(dest)}{encode(constant, 29 - 3 * INDEX_BIT)}')
    return data[a] // data[b]

def mod(a: int, b: int, dest:int, constant: int = 0) -> np.ndarray:
    instructions.append(f'100{encode(a)}{encode(b)}{encode(dest)}{encode(constant, 29 - 3 * INDEX_BIT)}')
    return data[a] % data[b]

def matmul(a: int, b: int, dest:int, constant: int = 0) -> np.ndarray:
    instructions.append(f'101{encode(a)}{encode(b)}{encode(dest)}{encode(constant, 29 - 3 * INDEX_BIT)}')
    return data[a] @ data[b]




for _ in range(data_size):
    data.append(np.pad(genData(row_size, col_size), ((0, pow(2, WIDTH_BIT)-row_size), (0, pow(2, WIDTH_BIT)-col_size)), "constant", constant_values=(0, 0)))



op = {0: add, 1: sub, 2: mul, 3: div, 4: mod, 5: matmul}
for i in range(instr_size):
    sel = random.randint(0,5)
    func = op[sel]
    ans.append(func(random.randint(0,data_size-1), random.randint(0,data_size-1), data_size+i))
        
        

with open("./testbench/instructions.txt", "w") as f:
    for instr in instructions:
        f.write(f'{instr}\n')
    f.write('1' * 32)   # end command              

with open("./testbench/data.txt", "w") as data_f:
    for d in data:
        s = ""
        for row in d:
            for value in row:
                s += encode(value, 32)
        print(s)
        data_f.write(s)
        data_f.write('\n')
with open("./testbench/ans.txt", "w") as ans_f:
    for a in ans:
        s = ""
        for row in a:
            for value in row:
                s += encode(value, 32)
        print(s)
        ans_f.write(s)
        ans_f.write('\n')

for d in data:
    print(d)

for i in range(len(ans)):
    print(f"ans{i}")
    print(ans[i])
