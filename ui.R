#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(Cairo)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Simple LM Model Builder"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
            actionButton("clear", "Clear points"),
            sliderInput("xexp",
                        "X scale (log):",
                        min = 1,
                        max = 6,
                        step=0.1,
                        value = 2),
            sliderInput("xshift",
                        "X origin:",
                        min = -0.5,
                        max = 0.5,
                        step=0.05,
                        value = 0),
            sliderInput("yexp",
                        "Y scale (log):",
                        min = 1,
                        max = 6,
                        step=0.1,
                        value = 2),
            sliderInput("yshift",
                        "Y origin:",
                        min = -0.5,
                        max = 0.5,
                        step=0.05,
                        value = 0)#,
            # radioButtons("documentation", "Documentation",
            #              c("On", "Off"), inline = TRUE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Model",
                                 plotOutput("arena",
                                            click = "plot_click",
                                            brush = brushOpts(
                                                    id = "plot_brush"
                                            ),
                                            dblclick = dblclickOpts(
                                                    id = "plot_dblclick"
                                            ),
                                            hover = hoverOpts(
                                                    id = "plot_hover"
                                            )
                                 ),
                                 tableOutput('coef')
                                 ),
                        tabPanel("Documentation",includeMarkdown("documentation.md"))))
)))
