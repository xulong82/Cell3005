#!/bin/bash
#PBS -l mem=64gb,nodes=1:ppn=20,walltime=50:00:00

module load R/3.1.1

# w/o parameter
  Rscript --no-restore --quiet ~/Dropbox/GitHub/SCR/GLM/glm.R

