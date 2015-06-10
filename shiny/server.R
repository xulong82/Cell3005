library(shiny)
library(shinyAce)
library(dplyr)
library(ggplot2)

load("shinyList.rdt")

bg <- shinyList$bg
marker <- shinyList$marker1
KEGG <- shinyList$KEGG
class <- shinyList$class
mode <- shinyList$mode
ci95_lo <- as.matrix(shinyList$ci95_lo)
ci95_hi <- as.matrix(shinyList$ci95_hi)
ci25 <- as.matrix(shinyList$ci25)
ci75 <- as.matrix(shinyList$ci75)

myhyper <- function(g1, g2) {  # Hypergeometric
  if(length(intersect(g1, g2)) == 0) return(1)
  1 - phyper(length(intersect(g1, g2)) - 1, length(g2), length(setdiff(bg, g2)), length(g1))
}  # Pr(count >= length(intersect(g1, g2)))

shinyServer(function(input, output) {
  
  output$expression <- renderPlot({
    geneId <- input$gene
    if(! geneId %in% rownames(mode)) stop("Input gene does not exist in the database.")
    
    graph2 = mutate(class, value = mode[geneId, as.character(level2class)], 
                    lo = ci25[geneId, as.character(level2class)],
                    hi = ci75[geneId, as.character(level2class)])
    
    ggplot(graph2, aes(x = level2class, y = value)) +  
      geom_point(aes(color = level1class), size = 3) + 
      geom_errorbar(aes(ymin = lo, ymax = hi, color = level1class)) + 
      theme_bw() + xlab("") + ylab("") + coord_flip() +
    # scale_fill_manual(values = col.manual) +
      theme(panel.border = element_rect(size = 1, color = "grey30"),
            axis.text = element_text(size = 10),
            legend.text = element_text(size = 10),
            legend.title = element_blank(), legend.key = element_blank()) 
    
  })
  
  output$geneList <- renderText({
    paste(marker[[input$cell]], collapse = ", ")
  })
  
  output$kegg <- renderTable({
    KEGG[[input$cell]]
  })
  
  get.text <- reactive({
    input$geneList
  })  
 
  output$enrichment <- renderPlot({
    
    symbols = as.matrix(read.table(text = get.text()))
    pvalue = unlist(lapply(marker, function(x) myhyper(symbols, x)))
    intersect = unlist(lapply(marker, function(x) length(intersect(symbols, x))))
    
    graph1 <- class %>% mutate(value = pvalue[as.character(level2class)])
    graph1$value = -log10(graph1$value)
    graph1$inter = intersect[as.character(class$level2class)]
                               
    ggplot(graph1, aes(x = level2class, y = value)) +  
      geom_point(aes(color = level1class, size = inter)) +
      geom_hline(yintercept = 1.3, color = "red", linetype = "dashed") +
      theme_bw() + xlab("") + ylab("") + 
      theme(panel.border = element_rect(size = 1, color = "grey30"),
            axis.text = element_text(size = 10, angle = 90),
            legend.text = element_text(size = 10),
            legend.title = element_blank(), legend.key = element_blank()) 
    
  }) 
  
})
