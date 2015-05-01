library(dplyr)
library(rstan)  # R/3.1.1

rm(list = ls())
cadillac <- "/data/xwang/SCR"
github <- "~/Dropbox/GitHub/SCR"

setwd(cadillac)
load("fit_sampling.rdt")  # GLM fit with Stan

setwd(github)
load("./data.rdt")  # Single Cell RNA-seq
cells <- data$cellInf[8, -1] %>% as.matrix %>% c %>% unique
load("rnaseq_howell.rdt")  # Cortex RNA-seq (Time series trans-APP)

# Gene expression per cell type as GLM estimations's mode
mode <- sapply(fit, function(x) {
  as.data.frame(x) %>% select(contains("beta")) %>%
  apply(2, function(y) {  # mode
    dens <- density(y); dens$x[which.max(dens$y)]
  })  # each cell's mode estimate of a single gene
}) %>% t
colnames(mode) <- c(cells, "basal")

# 95 credible interval: low end
summary <- lapply(fit, function(x) summary(x)$summary)
ci95 <- sapply(summary, function(x) x[, "2.5%"]) %>% t %>% as.data.frame %>% select(contains("beta"))
colnames(ci95) <- c(cells, "basal")
genes <- rownames(ci95)

# Markers
marker <- lapply(cells, function(x) genes[ci95[, x] > 3])
names(marker) <- cells
marker <- lapply(marker, function(x) x[! x%in% names(which(table(do.call(c, marker)) == 7))])
marker <- lapply(marker, function(x) x[x %in% rownames(howell)])

# X[sample, marker] and Y[cell, marker] matrices
X <- sapply(marker, function(x) apply(howell[x, ], 2, mean))
Y <- sapply(marker, function(x) apply(mode[x, cells], 2, function(y) median(y) / mad(y)))

pmca <- list()
pmca$X <- X
pmca$Y <- Y
save(pmca, file = "pmca.rdt")

