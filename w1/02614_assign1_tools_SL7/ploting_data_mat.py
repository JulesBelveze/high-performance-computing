import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

plt.figure();
#plt.style.use('seaborn-darkgrid')

dic = {
    "block": [],
    "block_300": [],
    "mnk_no_block": []
}

dic_x = {
    "block": [],
    "block_300": [],
    "mnk_no_block": []
}

mat_len = np.arange(36,2500,50)
permutations = ["block", "block_300","mnk_no_block"]
legends = ["bs 200", "bs 300","no bs"]


for elt in permutations:
    with open("data_files/matsize_vs_mflops/" + elt + ".txt") as f:
        old_val, it = -1, 0;
        
        for line in f:
            
            line = line.strip("\n");
            line = line.strip('');
            line = line.split();
            
            print(line)
            new_val = float(line[0]);
            if new_val == old_val:
                dic[elt][-1] += float(line[1]);
                it += 1;
            else:
                if len(dic[elt]) > 0:
                    dic[elt][-1] /= it;
                dic[elt].append(float(line[1]));
                it = 0;
                old_val = new_val;
        dic[elt][-1] /= it;
    
    plt.plot(mat_len, dic[elt], label=legends[list(dic.keys()).index(elt)]);


      
#plt.title("Performance according to the matrix size");
plt.ylabel("Performance (MFlops/s)");
plt.legend();
plt.xlabel("Matrix size");
plt.savefig("mflops_vs_matsize.png")