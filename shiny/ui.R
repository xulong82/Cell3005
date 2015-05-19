library(shiny)
library(shinyAce)

shinyUI(
  navbarPage("Single Cell RNA-seq", 
             tabPanel("Home",
                      fluidPage(
                        h2("News"),
                        p(strong("May 18, 2015."), "A web plugin for gene enrichment testing is released."),
                        p(strong("May 18, 2015."), "A web plugin for looking up a gene's expression profile in 47 cerebral cell types is released."),
                        hr(),
                        h3(a("Material and Methods", href="progress.html")),
                        p("Last updated: May 18, 2015."),
                        hr(),
	                      h3(a("GitHub Repository", href = "https://github.com/xulong82/SCR")),
                        hr()
                      )),
             
             tabPanel("Expression", 
                      fluidPage(
                        p(strong("Gene"), "expression as estimated by a generalized linear model. 
                          X-axis: absolute molecular counts. Y-axis: 47 cell types.
                          Point and errorbars are the first mode and 50% credible interval of the posterior bayesian distribution."),
                        hr(),
                        tags$div(textInput("gene", label = h5(""), value = "App"), align = "center", 
                                 submitButton("Submit")),
                        plotOutput("expression", height = "500px")
                      )),
             tabPanel("Enrichment", 
                      fluidPage(
                        p(strong("Infer"), "a gene list's cell origin by testing its enrichment of the 47 cell type's marker genes (hypergeometric test).
                          Point size means number of overlapping genes."),
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
