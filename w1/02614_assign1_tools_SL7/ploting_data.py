import matplotlib.pyplot as plt


mat1, mat2, mat3, x = [], [], [], []

with open("data_files/blk_1704825.txt") as f:
    k = 0;
    next(f);
    next(f);
    next(f);
    next(f);
    for line in f:
        line = line.strip("\n");
        line = line.strip('');
        line = line.split();
        
        if k%4 == 0:
            mat1.append(float(line[1]));
            x.append(int(line[5]));
        elif k%4 == 1:
            mat2.append(float(line[1]));
        elif k%4 == 2:
            mat3.append(float(line[1]));
            
        k += 1;
        

plt.figure();
plt.plot(x, mat1);
plt.plot(x, mat2);
plt.plot(x, mat3);

plt.savefig("test.png");
    