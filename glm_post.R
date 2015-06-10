library(dplyr)
library(rstan)  # R/3.1.1

rm(list = ls())
cadillac <- "/data/xwang/SCR"
github <- "~/Dropbox/GitHub/SCR"

setwd(cadillac)
load("level2/fit_sampling.rdt")  # GLM fit with Stan

setwd(github)
load("Rdt/rnaseq_howell.rdt")  # RNA-seq (Time series trans-APP)
load("Rdt/data.rdt")  # Single Cell RNA-seq
# cells <- data$cellInf[8, -1] %>% as.matrix %>% c %>% unique  # level 1
cells <- data$cellInf[9, -1] %>% as.matrix %>% c %>% unique  # level 2

# Gene expression as GLM estimations's mode

mode <- sapply(fit, function(x) {
  as.data.frame(x) %>% select(contains("beta")) %>%
  apply(2, function(y) {  # mode
    dens <- density(y); dens$x[which.max(dens$y)]
  })  # each cell's mode estimate of a single gene
}) %>% t
colnames(mode) <- c(cells, "basal")

# 95 credible interval: low end

summary <- lapply(fit, function(x) summary(x)$summary)
ci95_lo <- sapply(summary, function(x) x[, "2.5%"]) %>% t %>% as.data.frame %>% select(contains("beta"))
ci95_hi <- sapply(summary, function(x) x[, "97.5%"]) %>% t %>% as.data.frame %>% select(contains("beta"))
colnames(ci95_lo) <- colnames(ci95_hi) <- c(cells, "basal")

ci25 <- sapply(summary, function(x) x[, "25%"]) %>% t %>% as.data.frame %>% select(contains("beta"))
ci75 <- sapply(summary, function(x) x[, "75%"]) %>% t %>% as.data.frame %>% select(contains("beta"))
colnames(ci25) <- colnames(ci75) <- c(cells, "basal")

# Markers

marker <- sapply(cells, function(x) rownames(ci95_lo)[ci95_lo[, x] > 3])
marker1 <- lapply(marker, function(x) x[! x%in% names(which(table(do.call(c, marker)) == length(cells)))])
marker2 <- lapply(marker, function(x) x[x%in% names(which(table(do.call(c, marker)) < 10))])

# Enrichment

load("Rdt/glmList.rdt")  # background
for(obj in names(glmList)) assign(obj, glmList[[obj]])

myhyper <- function(g1, g2) {  # Hypergeometric
  if(length(intersect(g1, g2)) == 0) return(1)
  1 - phyper(length(intersect(g1, g2)) - 1, length(g2), length(setdiff(bg, g2)), length(g1))
}  # Pr(count >= length(intersect(g1, g2)))

lapply(marker2, function(x) myhyper(symbols, x))

# X[sample, marker] and Y[cell, marker] matrices

geneId <- intersect(rownames(howell), rownames(mode))
X <- howell[geneId, ] %>% t
Y <- mode[geneId, names(marker)] %>% t

marker <- lapply(marker, function(x) x[x %in% rownames(howell)])
X <- sapply(marker, function(x) apply(howell[x, ], 2, mean))
Y <- sapply(marker, function(x) apply(mode[x, names(marker)], 2, function(y) median(y) / mad(y)))

