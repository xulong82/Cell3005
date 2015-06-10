library(rstan)  # R/3.1.1
library(dplyr)
library(parallel)

rm(list = ls())
setwd("~/Dropbox/GitHub/SCR")

# GLM model
glm <- stan_model(file = "./GLM/glm_nb2.stan", model_name='GLM')

myGLM <- function(x) {
  fit1 <- lapply(1:nrow(x), function(i) { glm.dt$y <- x[i, ] 
    optimizing(glm, algorithm = "LBFGS", data = glm.dt)
#   sampling(glm, data = glm.dt, warmup = 3e2, iter = 6e2, chains = 3)
  }); names(fit1) <- rownames(x); return(fit1)
}

# SCR data
load("./data.rdt")

basal <- data$cellInf[2, -1] %>% as.matrix %>% as.numeric

# type <- data$cellInf[8, -1] %>% as.matrix %>% c  # type level 1
type <- data$cellInf[9, -1] %>% as.matrix %>% c  # type level 2
x <- sapply(unique(type), function(x) as.numeric(type == x))

x <- cbind(x, basal = basal / mean(basal))

glm.dt <- list(N = nrow(x), K = ncol(x), x = x)

ge <- data$mRNA[-c(1:10), -c(1:2)] %>% apply(2, as.numeric) 
rownames(ge) <- data$mRNA[-c(1:10), 1]

# Choose genes
ge <- ge[apply(ge, 1, function(x) sum(x > 10) > 1), ]

# PC
u.core <- round(nrow(ge) / 20)
idx1 <- (1:20 - 1) * u.core + 1; idx2 <- c(1:19 * u.core, nrow(ge))
geList <- lapply(1:20, function(x) ge[idx1[x]:idx2[x], ])

# y <- mclapply(geList, myGLM_optimizing, mc.cores = 20)
y <- mclapply(geList, myGLM, mc.cores = 20)
fit <- do.call(c, y)

  save(fit, file = "/data/xwang/SCR/fit_optimizing.rdt")
# save(fit, file = "/data/xwang/SCR/fit_sampling.rdt")

