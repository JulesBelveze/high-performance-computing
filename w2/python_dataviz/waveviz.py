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
# b = "13:59:44"
b = "14:23:05"

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
    surf = ax.plot_surface(
        X, Y, Z, cmap=cm.coolwarm, linewidth=3, antialiased=True, shade=True
    )
    # fig.colorbar(surf)
    fdfd = 1
    plt.xlim([-fdfd, fdfd])
    plt.ylim([fdfd, -fdfd])
    # ax.set_xlabel("X")
    # ax.set_ylabel("Y")
    # plt.set_zlim([0,20])
    # ax.set_zlabel("Z")
    ax.set_zlim(0, 20)
    ax.view_init(10, 15)
    ax.yaxis.set_major_locator(plt.NullLocator())
    ax.xaxis.set_major_formatter(plt.NullFormatter())

    fname = n
    plt.savefig("./w2/images/a1/" + str(n) + ".png", dpi=900)
    plt.show()


# %% Plot side by side
n1 = 8
n2 = 256
# ====================================
d = data[n1]
N = int(d[1].split(" ")[1])
ZZ = [x for b in d[4:-1] for x in [list(map(float, b.split(" ")[:-1]))]]
Z = np.array(ZZ)
X = np.arange(-1, 1, 2 / (N + 2))
Y = np.arange(-1, 1, 2 / (N + 2))
X, Y = np.meshgrid(X, Y)

fig = plt.figure(num=None, figsize=(8, 6), dpi=80, facecolor="w")

ax1 = fig.add_subplot(121, projection="3d")
surf1 = ax1.plot_surface(
    X, Y, Z, cmap=cm.coolwarm, linewidth=3, antialiased=True, shade=True
)
ax1.view_init(10, 15)
plt.title(str("N=" + str(N)))

# ====================================
d = data[n2]
N = int(d[1].split(" ")[1])
ZZ = [x for b in d[4:-1] for x in [list(map(float, b.split(" ")[:-1]))]]
Z = np.array(ZZ)
X = np.arange(-1, 1, 2 / (N + 2))
Y = np.arange(-1, 1, 2 / (N + 2))
X, Y = np.meshgrid(X, Y)

ax2 = fig.add_subplot(122, projection="3d")
surf2 = ax2.plot_surface(
    X, Y, Z, cmap=cm.coolwarm, linewidth=3, antialiased=True, shade=True
)
ax2.view_init(10, 15)
plt.title(str("N=" + str(N)))


plt.subplots_adjust(bottom=0.15, top=0.85)

plt.show()


# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# %% ========
# Plot side by side
n_radii = 8
n_angles = 36
radii = np.linspace(0.125, 1.0, n_radii)
angles = np.linspace(0, 2 * np.pi, n_angles, endpoint=False)
angles = np.repeat(angles[..., np.newaxis], n_radii, axis=1)
x = np.append(0, (radii * np.cos(angles)).flatten())
y = np.append(0, (radii * np.sin(angles)).flatten())
z1 = np.sin(-x * y)
z2 = np.cos(x ** 2)

# ---------
fig = plt.figure()
ax1 = fig.add_subplot(121, projection="3d")
surf1 = ax1.plot_trisurf(x, y, z1, cmap=cm.jet, antialiased=True)


plt.title("N=8")
plt.axis("off")
# ---------
ax2 = fig.add_subplot(122, projection="3d")
surf2 = ax2.plot_trisurf(x, y, z2, cmap=cm.jet, antialiased=True)

# plt.savefig("sample.png",bbox_inches='tight',dpi=100)
plt.axis("off")
plt.title("N=32")
plt.tight_layout()
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
