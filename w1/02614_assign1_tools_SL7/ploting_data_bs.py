import matplotlib.pyplot as plt
import seaborn as sns
plt.figure();
#plt.style.use('seaborn-darkgrid')

dic = {
    "1000": [],
    "1250": [],
    "1500": [],
    "1750": [],
    "2000": []
}

dic_x = {
    "1000": [],
    "1250": [],
    "1500": [],
    "1750": [],
    "2000": []
}


permutations = ["1000", "1250", "1500", "1750", "2000"]

for elt in permutations:
    with open("data_files/block/" + elt + ".txt") as f:
        old_val, it = -1, 0;
        
        for line in f:
            
            line = line.strip("\n");
            line = line.strip('');
            line = line.split();
            
            new_val = float(line[5]);
            if new_val == old_val:
                dic[elt][-1] += float(line[1]);
                it += 1;
            else:
                if len(dic[elt]) > 0:
                    dic[elt][-1] /= it;
                dic[elt].append(float(line[1]));
                dic_x[elt].append(float(line[5]));
                it = 0;
                old_val = new_val;
        dic[elt][-1] /= it;
    
    plt.plot(dic_x[elt], dic[elt], label=elt);


      
#plt.title("Performance according to block size");
plt.ylabel("Performance (MFlops/s)");
plt.legend();
plt.xlabel("Block size");
plt.savefig("block.png")