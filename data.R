library(dplyr)

rm(list = ls())
setwd("~/Dropbox/GitHub/SCR")

data <- list()

data$mRNA <- read.delim("raw/expression_mRNA_17-Aug-2014.txt.gz", stringsAsFactors = F)
data$mito <- read.delim("raw/expression_mito_17-Aug-2014.txt.gz", stringsAsFactors = F)
data$spikes <- read.delim("raw/expression_spikes_17-Aug-2014.txt.gz", stringsAsFactors = F)

data$cellInf <- data$mRNA[1:10, -1]

level1class <- data$mRNA[8, -c(1:2)] %>% as.character
level2class <- data$mRNA[9, -c(1:2)] %>% as.character 

mRNA <- data$mRNA[-c(1:10), -c(1:2)] %>% apply(2, as.numeric) %>% as.data.frame 
level1avg <- sapply(1:nrow(mRNA), function(x) tapply(as.matrix(mRNA[x, ]), level1class, mean)) %>% t
level2avg <- sapply(1:nrow(mRNA), function(x) tapply(as.matrix(mRNA[x, ]), level2class, mean)) %>% t
rownames(level1avg) <- rownames(level2avg) <- data$mRNA[-c(1:10), 1]

data$level1avg <- as.data.frame(level1avg)
data$level2avg <- as.data.frame(level2avg)

save(data, file = "./data.rdt")

class <- cbind(level1class, level2class) %>% as.data.frame
class <- class[! duplicated(class), ] %>% filter(level2class != "(none)")
save(class, file = "./class.rdt")

ggplot()
