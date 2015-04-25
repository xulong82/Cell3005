rm(list = ls()); setwd("~/Dropbox/GitHub/Cortex")

library(dplyr)

data <- list()

data$mRNA <- read.delim("data/expression_mRNA_17-Aug-2014.txt.gz", stringsAsFactors = F)
data$mito <- read.delim("data/expression_mito_17-Aug-2014.txt.gz", stringsAsFactors = F)
data$spikes <- read.delim("data/expression_spikes_17-Aug-2014.txt.gz", stringsAsFactors = F)

level1class <- data$mRNA[8, -c(1:2)] %>% as.character
level2class <- data$mRNA[9, -c(1:2)] %>% as.character 

mRNA <- data$mRNA[-c(1:10), -c(1:2)] %>% apply(2, as.numeric) %>% as.data.frame 
level2avg <- sapply(1:nrow(mRNA), function(x) tapply(as.matrix(mRNA[x, ]), level2class, mean)) %>% t
rownames(level2avg) <- data$mRNA[-c(1:10), 1]

data$level2avg <- as.data.frame(level2avg)
save(data, file = "data.rdt")

load("data.rdt")
level2avg <- data$level2avg %>% as.matrix
barplot(level2avg["App", ], las = 2)
barplot(level2avg["Stat3", ], las = 2)

mRNA <- data$mRNA[-c(1:10), -c(1:2)] %>% apply(2, as.numeric) %>% as.data.frame 
rownames(mRNA) <- rownames(level2avg)
summary(c(as.matrix(mRNA["Stat3", ])))

allen <- read.xlsx(file = "../Adsp/GWAS/table_new.xlsx", sheetName = "ALLEN") 
adsp <- level2avg[rownames(level2avg) %in% as.character(allen$SYMBOL), ]
lapply(1:nrow(adsp), function(x) barplot(adsp[x, ], las = 2, main = rownames(adsp)[x]))
barplot(adsp["Ryr2", ], las = 2)
barplot(level2avg["Apoe", ], las = 2)
