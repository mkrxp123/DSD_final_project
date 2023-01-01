from pathlib import Path
import numpy as np

Path("./testbench").mkdir(parents=True, exist_ok=True)

data = []
instructions = []
INDEX_BIT = 5
PADDING = '0' * (29 - 3 * INDEX_BIT)

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

data.append(genData(3, 4))
data.append(genData(3, 4))
data.append(genData(3, 4))

data.append(add(0, 1, 3))
data.append(mul(0, 3, 4))

with open("./testbench/instructions.txt", "w") as f:
    for instr in instructions:
        f.write(f'{instr}\n')
    f.write('1' * 32)   # end command