library(shiny)

shinyUI(
  navbarPage("Single Cell RNA-seq", 
             tabPanel("Documents",
                      fluidPage(
                        p(strong(a(href="progress.html", "Uploaded: May 1, 2015."))),
                        hr(),
	                      h1(a("GitHub Repository", href = "https://github.com/xulong82/SCR"))
                      ))
            
))
