import os
import matplotlib.pyplot as plt
import numpy as np

# should return true
"w1" in os.listdir("./")

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


# %% Load and average textfile content, store structured dict[opt][perm][matrix]
dir1 = "./w1/02614_assign1_tools_SL7/15:02:26"
dataa = {}
for opt in os.listdir(dir1):  # iterate over optimizations
    # print("-" + opt)
    if opt not in dataa.keys():
        dataa[opt] = {}
    dir2 = dir1 + "/" + opt
    for perm in os.listdir(dir2):  # iterate over permutations
        # print("--" + perm)
        if perm not in dataa[opt].keys():
            dataa[opt][perm] = {}
        dir3 = dir2 + "/" + perm
        for run in os.listdir(dir3):  # iterate over matrix size + run
            # print("---" + run)
            dir4 = dir3 + "/" + run
            run = int(run.split("_")[0])
            if run not in dataa[opt][perm].keys():
                dataa[opt][perm][run] = []
            with open(dir4, "r") as f:
                read_data = f.read()
                read_data = read_data.split("\n")[0:-2]
                read_data = [float(i) for i in read_data]
                dataa[opt][perm][run].append(np.mean(read_data))
    #         break
    #     break
    # break

# Mean across runs
for opt in dataa.keys():
    # print(opt)
    for perm in dataa[opt].keys():
        # print('-'+perm)
        for m_size in dataa[opt][perm].keys():
            # print('--'+m_size)
            dataa[opt][perm][m_size] = np.mean(dataa[opt][perm][m_size])
#             break
#         break
#     break
# break
#
# %%

opt = "Ofast"
perm = "nkm"
# x, y = zip(*dataa[opt][perm].items())

# a = [x.split(",") for x in read_data.split("\n") if len(x) > 0]
#
# x, y = zip(*[(float(x[0]), float(x[1])) for x in a])
for perm in dataa[opt].keys():
    x, y = zip(*sorted(dataa[opt][perm].items()))
    plt.plot(x, y, alpha=0.9, label=perm, lw=5)
plt.legend()
# plt.scatter(x, y)
plt.xlim([800, 2000])
plt.ylim([0, 10])
# title = str(r'Permuation comparison using $\mathtt{'+ opt + "}$ optimization")
# plt.title(title)
plt.ylabel("Runtime (ms)")
plt.xlabel("Matrix Size")
# plt.figure(figsize=(7, 7))  # This increases resolution
plt.savefig("./images/runtime_0fast_allopts.png", dpi=900)  # This does, too
# plt.savefig("./images/runtime_0fast_allopts.png")
plt.show()

# %% table of
# \begin{center}
#  \begin{tabular}{||c c c c||}
#  \hline
#  Col1 & Col2 & Col2 & Col3 \\ [0.5ex]
#  \hline\hline
#  1 & 6 & 87837 & 787 \\
#  \hline
#  2 & 7 & 78 & 5415 \\
#  \hline
#  3 & 545 & 778 & 7507 \\
#  \hline
#  4 & 545 & 18744 & 7560 \\
#  \hline
#  5 & 88 & 788 & 6344 \\ [1ex]
#  \hline
# \end{tabular}
# \end{center}
s = "\\begin{center}\n"
s += "\\begin{tabular}"
s += "{||" + " ".join(["c |" for opt in ["h"] + list(dataa.keys())]) + "|}\n"
s += "\\hline\n"
s += "." + "".join([" & " + opt for opt in dataa.keys()]) + "\\\\ [0.5ex]\n"
s += "\\hline\\hline\n"
opt = "Ofast"
for perm in dataa[opt].keys():
    # a = "".join([" & "+perm for perm in dataa.keys()]) + "\\\\"
    s += perm
    b = [np.mean(list(zip(*dataa[opt][perm].items()))[1]) for i in dataa.keys()]
    s += "".join([" & " + str(round(i, 2)) for i in b]) + "\\\\\n"
    # print(b)
    s += "\\hline\n"
s += "\\end{tabular}\n"
s += "\\end{center}\n"


# for opt in [''] list(dataa.keys()):
#     s += opt + " & "
# s+= " & ".join([opt for opt in dataa.keys()]) + "\\\\ [0.5ex]\n"

print(s)
## %%
# print("\\begin{tabular}")

for opt in dataa.keys():
    # list of perm-tuples containing runtimes for different matrix sizes
    a = [(sorted(dataa[opt][perm].items()), perm) for perm in dataa[opt].keys()]
    [(np.mean(list(zip(*i[0]))[1]), i[1]) for i in a]
    # list of perm-tuples containing aveerage runtime for matrices
    # b = [(np.mean(list(zip(*i[0]))[1]), i[1]) for i in a]
    # c = [(np.mean(list(zip(*i[0]))[1]), i[1]) for i in a]
    # fastest permutation with this optimization
    print(a)

# %% find best performing permuation for each optimization
top_perms = {}
for opt in dataa.keys():
    # list of perm-tuples containing runtimes for different matrix sizes
    a = [(sorted(dataa[opt][perm].items()), perm) for perm in dataa[opt].keys()]
    # list of perm-tuples containing aveerage runtime for matrices
    b = [(np.mean(list(zip(*i[0]))[1]), i[1]) for i in a]
    # fastest permutation with this optimization
    fperm = [i[1] for i in b if i[0] == min(list(zip(*b))[0])][0]
    top_perms[opt] = fperm

# %%
for (opt, perm) in list(top_perms.items()):
    # print(dataa[opt][perm])
    x, y = zip(*sorted(dataa[opt][perm].items()))
    plt.plot(x, y, alpha=0.9, label=str(opt + "+" + perm), lw=5)
plt.legend()
# plt.scatter(x, y)
plt.xlim([200, 2000])
plt.ylim([0, 10])
# title = str(r'Permuation comparison using $\mathtt{'+ opt + "}$ optimization")
# plt.title(title)
plt.ylabel("Runtime (ms)")
plt.xlabel("Matrix Size")
plt.savefig("./images/runtime_allopts_topops.png", dpi=900)  # This does, too
plt.show()

#%%

for (opt, perm) in list(top_perms.items()):
    # print(dataa[opt][perm])
    x, y = zip(*sorted(dataa[opt][perm].items()))
    plt.plot(x, y, alpha=0.9, label=str(opt + "+" + perm), lw=5)
plt.legend()
# plt.scatter(x, y)
plt.xlim([1800, 2000])
plt.ylim([5.5, 6.5])
# title = str(r'Permuation comparison using $\mathtt{'+ opt + "}$ optimization")
# plt.title(title)
plt.ylabel("Runtime (ms)")
plt.xlabel("Matrix Size")
plt.savefig("./images/runtime_allopts_topops_zoom.png", dpi=900)  # This does, too
plt.show()


#
# for perm in dataa[opt].keys():
#     x, y = zip(*sorted(dataa[opt][perm].items()))
#     print(perm, max(y))
