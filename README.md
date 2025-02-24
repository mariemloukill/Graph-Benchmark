# Graph-Benchmark

## Overview

Graph-Benchmark is a project designed to [provide a brief description of what your project does]. This repository includes:

- `metrics_collection.sh`: A shell script for collecting performance metrics.
- `performance_all.xlsx`: An Excel file compiling performance data results.
- `executions.txt`, `executions_Mmap.txt`, `executions_gpop.txt`: Text files containing the different frameworks workloads.

## Installation

To set up the project locally, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/mariemloukill/Graph-Benchmark.git
   cd Graph-Benchmark
2. **Set up the framework that will be used for benchmarks**
   
   In this case, install and set up [GraphChi](https://github.com/GraphChi/graphchi-cpp), [Ligra](https://github.com/jshun/ligra), [X-Stream](https://github.com/bindscha/x-stream), [Mmap](https://poloclub.gatech.edu/mmap/), [GridGraph](https://github.com/thu-pacman/GridGraph), [GPOP](https://github.com/thu-pacman/GridGraph)


## Usage

### Setting Up

Before running the benchmarks, ensure that:
1. Each framework is installed and set up correctly.
2. All necessary preprocessing and data conversion steps are completed for each framework to avoid errors. We have included these steps in `metrics.txt` we consider them as workloads and having data about how these steps are performed is important to our project.
3. Workloads are defined in the `metrics.txt` file in the format and structure required by each framework.
4. The sar command must be installed on your system for resource monitoring. If not installed, you can install it using:
```bash
sudo apt-get install sysstat  # For Debian/Ubuntu-based systems
```
### Workload Configuration (`metrics.txt`)

The `metrics.txt` file contains the workloads to be executed by the script. Each line in the file follows this structure:

`framework, workload, dataset, "command"`

- **framework**: The name of the framework (e.g., GraphChi, Ligra, X-Stream, Mmap, GridGraph, GPOP).
- **workload**: The type of workload (e.g., PageRank10).
- **dataset**: The dataset to be used (e.g., soc-LiveJournal1, com-orkut). All datasets were downloaded from [Stanford Network Analysis Project (SNAP)](https://snap.stanford.edu/)
- **command**: The actual command to run the workload, enclosed in quotes. Ensure the command respects the required format and structure for the respective framework.

#### Example Workloads:
Here are examples for each framework:
- GraphChi

`GraphChi,PageRank10,soc-LiveJournal1,"./graphchi-cpp/bin/example_apps/pagerank filetype edgelist file datasets/soc-LiveJournal1.txt niters 10"`

- Ligra
  
`Ligra,PageRank10,com-orkut,"./ligra/apps/PageRank -maxiters 10 -rounds 1 ligra/datasets/com-orkut_adj.txt"`

- X-Stream
- 
`X-Stream,Pagerank10,com-orkut,"./x-stream/bin/benchmark_driver -b pagerank --pagerank::niters 10 -g x-stream/com-orkut_bin.txt --physical_memory 15032385536"`

- Mmap
  
`Mmap,PageRank10,soc-LiveJournal1,"java -jar mmap.jar PageRank soc-LiveJournal1.txt.bin 4847571 10"`

- GridGraph
  
`GridGraph,PageRank10,live-journal,"./GridGraph/bin/pagerank GridGraph/data/LiveJournal_Grid 10 16"`

- GPOP
  
`GPOP,PageRank10,live-journal,"./GPOP/pr/pr binary_datasets/soc-LiveJournal1_csrbin.txt -iter 10 -rounds 1"`

### Script Configuration (`metrics_collection.sh`)

It is possible (yet not required) to configure the following parameters for the benchmark: 
#### Variables:
- `output_file="performance_data.csv"`: The file where performance data will be saved.
- `sar_interval=1`: The interval in seconds for `sar` measurements (used for system resource monitoring).
- `exec_file="executions.txt"`: The input file containing the execution commands (e.g., `metrics.txt`).
- `num_runs=5`: The number of times each command will be executed.


### Running the script: 
 - Ensure the script has execution permissions:
     ```bash
     chmod +x metrics_collection.sh
     ```
- Run the script:
     ```bash
     ./metrics_collection.sh
     ```

  It is recommended to run each framework's metrics collection script individually and within the framework's folder. This avoids issues related to directory and path changes.  To do so, navigate to the framework's directory and create a copy of `metrics_collection.sh` and a specific workloads' file (e.g. executions_Mmap.txt). Ensure the script's  `exec_file` variable points to the correct input file (e.g., executions_Mmap.txt).

