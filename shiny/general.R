setwd("~/Dropbox/GitHub/SCR")

load("est.rdt")
load("class.rdt")
load("bg.rdt")
load("marker.rdt")

shinyList = list()

shinyList$mode = mode
shinyList$ci95_hi = ci95_hi
shinyList$ci95_lo = ci95_lo
shinyList$class = class
shinyList$marker = marker
shinyList$bg = bg

save(shinyList, file = "shinyList.rdt")
