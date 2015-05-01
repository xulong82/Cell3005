library(shiny)

shinyUI(
  navbarPage("Single Cell RNA-seq", 
             tabPanel("Documents",
                      fluidPage(
                        h2(a("Progress report", href="progress.html")),
                        p("Last updated: May 1, 2015."),
                        hr(),
	                      h1(a("GitHub Repository", href = "https://github.com/xulong82/SCR"))
                      ))
            
))
