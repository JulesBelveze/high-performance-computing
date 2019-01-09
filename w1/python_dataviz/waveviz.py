import os
import matplotlib.pyplot as plt

dir = "./HPC/"
os.listdir(dir)

#%%

with open("HPC/w1/ex1_4/matrix_generate.txt") as f:
    read_data = f.read()

a = [x.split(",") for x in read_data.split("\n") if len(x) > 0]

x, y = zip(*[(float(x[0]), float(x[1])) for x in a])

plt.scatter(x, y)
plt.title("Matrix Generate Runtime as Matrix Axes increase")
plt.ylabel("Run time (ms)")
plt.xlabel("Size N")
plt.savefig("HPC/images/w1_matrix_generate.png")
plt.show()


#%%
with open("HPC/w1/ex1_4/matrix_matrix_mult.txt") as f:
    read_data = f.read()

a = [x.split(",") for x in read_data.split("\n") if len(x) > 0]

x, y = zip(*[(float(x[0]), float(x[1])) for x in a])

plt.scatter(x, y)
plt.title("Matrix Multiplication Runtime as Matrix Dimensions increase")
plt.ylabel("Run time (ms)")
plt.xlabel("Size N")
plt.savefig("HPC/images/w1_matrix_matrix_mult.png")
plt.show()

#%%

#%%
