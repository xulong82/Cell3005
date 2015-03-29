library(rhdf5)

rm(list = ls())
setwd("~/Desktop/SC2015")

h5createFile("sc3005.h5")
h5createGroup("sc3005.h5", "raw")

h5ls("sc3005.h5")

mito <- read.delim("expression_mito_17-Aug-2014.txt", stringsAsFactors = F)
mRNA <- read.delim("expression_mRNA_17-Aug-2014.txt", stringsAsFactors = F)
spikes <- read.delim("expression_spikes_17-Aug-2014.txt", stringsAsFactors = F)

x = as.data.frame(matrix(1, nrow = 1e4, ncol = 1e4))

df = data.frame(1L:5L,seq(0,1,length.out=5), c("ab","cde","fghi","a","s"), stringsAsFactors=FALSE)

print(object.size(mRNA), units = "Gb")
print(object.size(x), units = "Gb")

h5write(df, "sc3005.h5", "df")
h5write(as.matrix(mRNA), "sc3005.h5", "mRNA")
h5write(mito[1:20, 1:5], "sc3005.h5", "raw/mito5")

h5createDataset("sc3005.h5", "mRNA1", dims = dim(mRNA), storage.mode = storage.mode(mRNA), chunk= c(dim(mRNA)[1], dim(mRNA)[2],1,1))
h5createDataset("sc3005.h5", "raw/mRNA2", dim(mRNA), chunk = c(5, 1), level = 7)
h5write(mRNA, "sc3005.h5", name = "raw/mRNA2")

a = rep(10, 10)
h5write(a, "sc3005.h5", "raw/mito")
