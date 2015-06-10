library(shiny)
library(shinyAce)

load("shinyList.rdt")

shinyUI(
  navbarPage("Single Cell RNA-seq", 
             tabPanel("Home",
                      fluidPage(
                        h2("News"),
                        p(strong("May 18, 2015."), "A web plugin for gene enrichment testing was released."),
                        p(strong("May 18, 2015."), "A web plugin for looking up gene's expression profile in 47 cerebral cell types was released."),
                        hr(),
                        h3(a("Material and Methods", href="progress.html")),
                        p("Last updated: May 18, 2015."),
                        hr(),
	                      h3(a("GitHub Repository", href = "https://github.com/xulong82/SCR")),
                        hr()
                      )),
             
             tabPanel("Expression", 
                      fluidPage(
                        p(strong("Gene"), "expression in 47 cerebral cell classes (Y-axis). 
                        The x-axis is the absolute molecular counts (AMC) of the gene in the given cell.
                        AMC was estimated by fitting a generalized linear model with MCMC sampling, 
                        and quantified by its posterior distribution's first mode (point) and 50% credible interval (errorbar)."),
                        hr(),
                        tags$div(textInput("gene", label = h5(""), value = "App"), align = "center", 
                                 submitButton("Submit")),
                        plotOutput("expression", height = "500px")
                      )),
             tabPanel("Marker", 
                      fluidPage(
                        p(strong("KEGG"), "enrichment of the 47 cerebral cell-classes."),
                        hr(),
                        fluidRow(
                          column(3,
                                 selectInput("cell", "Choose a cell", choices = names(shinyList$KEGG), selected = "Int10"),
                                 submitButton("Submit")
                          ),
                          column(9,
                                 tableOutput("kegg")
                          ))
                      )),
             tabPanel("Enrichment", 
                      fluidPage(
                        p(strong("Testing"), "a gene list's cell enrichment by hypergeometric test using cell type-specific marker genes.
                          Point size means number of overlapping genes."),
                        helpText("Please type or paste your gene list in the text box. Only mouse gene symbol is supported (Stat1, Gfap, Hspa2)."),
                        hr(),
                        fluidRow(
                          column(3,
                                 aceEditor("geneList", value= "App", mode="plain_text", theme="textmate"),
                                 submitButton("Submit")
                          ),
                          column(9,
                                 plotOutput("enrichment")
                          ))
                      ))
))
