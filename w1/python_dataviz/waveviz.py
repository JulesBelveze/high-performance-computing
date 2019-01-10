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
# ssh to HPC list subdirs
# ls ~/Documents/HPC/w1/02614_assign1_tools_SL7/15\:02\:26/O0/

# Mount HPC drive, changedir to timestamp directory
# cd ~/Documents/HPC/w1/02614_assign1_tools_SL7/15:02:26

# Timestamp subdir (O0, O1, O2,... OS) are types of optimization
# Optmization subdirs (mnk, mkn ... nkm) are types of permuations
# Permutations subfiles (1_2.txt ... 1921_5.txt) are matrix sizes + repitions.
# Subfile 481_3.txt is the third repititions of m,n,k = 481.
# The first n-1 lines are times to be averaged
# The 5 versions of each file are also be averaged.
#
