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
b = "10:39:16"
textfiles = [t for t in glob.glob("**/" + b + "/*.txt", recursive=True)]
textfiles


data = {}
for t in textfiles:
    N = int(t.split(".")[0].split("/")[-1])
    readl = open(t).read().split("\n")
    data[N] = readl

# %%

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
    # ax.view_init(230, 30)
    # ax.view_init(230, 60)
    # plt.savefig("./images/runtime_allopts_topops_zoom.png", dpi=900)
    plt.show()
# %%

from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import numpy as np


fig = plt.figure()
ax = fig.gca(projection="3d")

# Make data.
X = np.arange(-5, 5, 0.25)
Y = np.arange(-5, 5, 0.25)
X, Y = np.meshgrid(X, Y)


R = np.sqrt(X ** 2 + Y ** 2)

Z = np.sin(R)

# Plot the surface.
surf = ax.plot_surface(X, Y, Z, cmap=cm.coolwarm, linewidth=0, antialiased=False)

# Customize the z axis.
ax.set_zlim(-1.01, 1.01)
ax.zaxis.set_major_locator(LinearLocator(10))
ax.zaxis.set_major_formatter(FormatStrFormatter("%.02f"))

# Add a color bar which maps values to colors.
fig.colorbar(surf, shrink=0.5, aspect=5)

plt.show()

#%%
