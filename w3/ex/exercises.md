# ex1_devicequery

2. Differences in CPUs and GPUs

|                | CPU            | GPU     |
| :------------- | :------------- | :------------- |
| Count          | 23             | 2              |
| Core count     | ...            |   ...          |
| Clock cycles   | ...            |   ...          |
| Cache size     | ...            |   ...          |
| Main memory    | ...            |   ...          |

## 3

| Memory+Transfer| Memory Bandwidth (MB/s) |
| :------------- | :-------------          |
| Pinner H2D     | 12027.9                 |
| Pinner D2H     | 12853.5                 |
| Pinner D2D     | 734289.7                |
| Pageable H2D   | 4554.4                  |
| Pageable D2H   | 4555.3                  |
| Pageable D2D   | 733138.4                |

## 4
```bash
# compiling cuda code
nvcc -I/appl/cuda/10.0/samples/common/inc myDeviceQuery.cu -o myDeviceQuery

# running the code
./myDeviceQuery
```

# Notes

## Memory on GPU
* Fastest memory is local memory.
  * Local memory is per thread cannot be read by other threads.
* Shared memory is next fastest
  * Shared amongst threads in a block
* Globab memory (on GPU)
* Host memory (reached through)

## Pinned host memory
