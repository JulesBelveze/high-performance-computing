import os
import matplotlib.pyplot as plt
import numpy as np
import glob
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter


"w2" in os.listdir("./")
#%%
# b = "17:27:28"
# b = "10:34:49"
# b = "10:39:16"
# b = "12:02:39"
# b = "12:08:50"
# b = "13:48:53"
b = "13:59:44"

textfiles = [t for t in glob.glob("**/" + b + "/*.txt", recursive=True)]
textfiles


data = {}
for t in textfiles:
    N = int(t.split(".")[0].split("/")[-1])
    readl = open(t).read().split("\n")
    data[N] = readl

# %%

data[4]

# %%
for n in sorted(list(data.keys())):
    d = data[n]
    N = int(d[1].split(" ")[1])
    print(N)
    ZZ = [x for b in d[4:-1] for x in [list(map(float, b.split(" ")[:-1]))]]
    Z = np.array(ZZ)
    X = np.arange(-1, 1, 2 / (N + 2))
    Y = np.arange(-1, 1, 2 / (N + 2))
    X, Y = np.meshgrid(X, Y)

    fig = plt.figure()
    ax = fig.gca(projection="3d")
    surf = ax.plot_surface(X, Y, Z, cmap=cm.coolwarm, linewidth=1, antialiased=True)
    # ax.zaxis.set_major_locator(LinearLocator(10))
    # ax.zaxis.set_major_formatter(FormatStrFormatter("%.02f"))
    fig.colorbar(surf)
    fdfd = 1
    plt.xlim([-fdfd, fdfd])
    plt.ylim([fdfd, -fdfd])
    ax.set_xlabel("X")
    ax.set_ylabel("Y")
    # plt.set_zlim([0,20])
    ax.set_zlabel("Z")
    ax.set_zlim(0, 30)
    ax.view_init(30, 240)
    # ax.view_init(230, 60)
    # plt.savefig("./images/runtime_allopts_topops_zoom.png", dpi=900)
    plt.show()
# %%
for n in sorted(list(data.keys()))[0:4]:
    d = data[n]
    N = int(d[1].split(" ")[1])
    print(N)
    ZZ = [x for b in d[4:-1] for x in [list(map(float, b.split(" ")[:-1]))]]
    Z = np.array(ZZ)
    X = np.arange(-1, 1, 2 / (N + 2))
    Y = np.arange(-1, 1, 2 / (N + 2))
    X, Y = np.meshgrid(X, Y)

    fig, ax = plt.subplots()

    for i in range(Z.shape[0]):
        for j in range(Z.shape[1]):
            ax.scatter(i, j, color="b", s=20, alpha=Z[i, j] / 20, edgecolors="none")
            # print(i,j,Z[i,j],Z[i,j]/20)

    plt.show()

#%%
x
