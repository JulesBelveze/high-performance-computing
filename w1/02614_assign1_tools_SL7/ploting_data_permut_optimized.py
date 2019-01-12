import matplotlib.pyplot as plt
import seaborn as sns
plt.figure();
#plt.style.use('seaborn-darkgrid')

dic = {
    "kmn": [],
    "knm": [],
    "mnk": [],
    "mkn": [],
    "nkm": [],
    "nmk": []
}

dic_x = {
    "kmn": [],
    "knm": [],
    "mnk": [],
    "mkn": [],
    "nkm": [],
    "nmk": []
}


permutations = ["kmn", "knm", "mnk", "mkn", "nkm", "nmk"]

for elt in permutations:
    with open("data_files/permut_opt_/" + elt + ".txt") as f:
        old_val, it = 0, 0;

        for line in f:

            line = line.strip("\n");
            line = line.strip('');
            line = line.split();

            new_val = float(line[0]);
            if new_val == old_val:
                dic[elt][-1] += float(line[1]);
                it += 1;
            else:
                if len(dic[elt]) > 0:
                    dic[elt][-1] /= it;
                dic[elt].append(float(line[1]));
                dic_x[elt].append(float(line[0]));
                it = 0;
                old_val = new_val;
        dic[elt][-1] /= it;

    plt.semilogx(dic_x[elt], dic[elt], label=elt);



#plt.title("Optimized permutations");
plt.ylabel("Performance (MFlops/s)");
plt.legend();
plt.xlabel("Memory (KB)");
plt.savefig("permutations_optimized.png")
