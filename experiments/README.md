# Experiments

This directory has the [Popperized](http://falsifiable.us/) experiments for
CudeleFS and PaulOcto. This repository has the following experiments:

- **baseliner**: verifies cluster/per-disk write bandwidth and network speed.

- **n1**: baselines PLFS workloads, which transforms N:N workloads to N:1.

- **nn**: baselines N:N workloads on CephFS.

- **nn-cudele**: micro and macrobenchmarks that show improvements over `nn`.


## Running Experiments

Inside each experiment directory there is:

- `visualize.ipnyb`: Python Notebook that has the graphs from the paper, along
  with some information about the experiment itself. 

` `run.sh`: some sort of run script that launches the experiment.

In this directory, there is:

- `run.sh`: runs all experiments.

- `conf/`: directory with all the configurations for the experiment.

- `conf/hosts/`: directory with all the cluster setups; experiments iterate
  over this directory for scalability experiments.

- `viz_jupiter.sh`: launches a Docker container that renders experiment graphs
  (`visualize.ipynb`).
