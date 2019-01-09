import os
import matplotlib.pyplot as plt

dir = './dataviz/wave_labs/'
os.listdir(dir)

with open(dir+'wave.dat') as f:
    read_data = f.read()

a = [x.split() for x in read_data.split('\n')]

b = [[x[0],x[2]] if len(x)==3 else x for x in a if len(x)>0]

x,y = zip(*[(float(x[0]),float(x[1])) for x in b])

plt.scatter(x,y)
plt.show()


#%%

with open('/Users/dth/Documents/DTU/Semester 10/02614 - High Performance Computing/HPC/w1/d1/1_mat_add/test.txt') as f:
    read_data = f.read()

a = [x.split(',') for x in read_data.split('\n') if len(x)>0]

x,y = zip(*[(float(x[0]),float(x[1])) for x in a])

plt.scatter(x,y)
plt.title('Matrix Add runtime as matrix axes increase')
plt.ylabel('Run time (ms)')
plt.xlabel('Size N')
plt.savefig('HPC/w1/d1/1_mat_add/matrix_add.png')
plt.show()


#%%
with open('HPC/w1/d1/1_mat_add/matrix_generate.txt') as f:
    read_data = f.read()

a = [x.split(',') for x in read_data.split('\n') if len(x)>0]

x,y = zip(*[(float(x[0]),float(x[1])) for x in a])

plt.scatter(x,y)
plt.title('Matrix Generation runtime as matrix axes increase')
plt.ylabel('Run time (ms)')
plt.xlabel('Size N')
plt.savefig('HPC/w1/d1/1_mat_add/matrix_generate.png')
plt.show()

#%%
with open('HPC/w1/d1/1_mat_add/matrix_matrix_mult.txt') as f:
    read_data = f.read()

a = [x.split(',') for x in read_data.split('\n') if len(x)>0]

x,y = zip(*[(float(x[0]),float(x[1])) for x in a])

plt.scatter(x,y)
plt.title('Matrix Multiplication Runtime as Matrix Dimensions increase')
plt.ylabel('Run time (ms)')
plt.xlabel('Size N')
plt.savefig('HPC/w1/d1/1_mat_add/matrix_matrix_mult.png')
plt.show()
