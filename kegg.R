library(GOstats)
library(KEGG.db)
library(org.Mm.eg.db)
library(Category)
library(dplyr)

setwd("~/Dropbox/GitHub/SCR")

load("shiny/shinyList.rdt")  # background
for(obj in names(shinyList)) assign(obj, shinyList[[obj]])

kegg <- function (geneId) {
  entrezId <- mget(geneId, org.Mm.egSYMBOL2EG, ifnotfound = NA) %>% unlist %>% na.omit %>% as.character
  if(! length(entrezId) > 1) return(NA) # use nsFilter() for additional filtering if required
  bg <- get("org.Mm.egPATH") %>% Lkeys
  
  over <- new("KEGGHyperGParams", geneIds=entrezId, universeGeneIds=bg, annotation="org.Mm.eg.db", 
              categoryName="KEGG", pvalueCutoff = 0.05, testDirection="over") %>% hyperGTest
  glist <- sapply(geneIdsByCategory(over), function(x) {y <- mget(x, envir=org.Mm.egSYMBOL); paste(y, collapse=", ")})
  kegg <- summary(over); kegg$Symbols <- glist[as.character(kegg$KEGGID)]
  
  return(kegg)
}

shinyList$KEGG <- lapply(marker, kegg)

library(xlsx)
module <- read.xlsx("TableS1.xlsx", sheetName = "Modules", stringsAsFactors = F)
module <- module[-1, ]

KEGG = apply(module, 2, kegg)
