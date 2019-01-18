from os import listdir
from os.path import isfile, join

folder = "./mflops_msize_danny"
out_folder = "./parallel/size/"
out_map = [100, 500, 1000, 15000, 20000]
for f in listdir(folder):
    if isfile(join(folder, f)):
        thread_count = f[:1]
        alg = f.split(".")[0][-1:]
        if alg != "6":
            continue
        with open(join(folder, f)) as file:
            lines = file.readlines()
            for index, line in enumerate(lines):
                time = line.rstrip("\n")
                with open(join(out_folder, f"{thread_count}.txt"), "a+") as write_file:
                    write_file.write(f"{time} {out_map[index]}\n")
