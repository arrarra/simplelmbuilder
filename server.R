#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# https://arrarra.shinyapps.io/simplelm/
#
library(shiny)
library(dplyr)
library(ggplot2)
library(Cairo)

shinyServer(function(input, output) {
   
        vals <- reactiveValues(
                points = data.frame(x=numeric(), y=numeric()),
                fit = NULL
        )
        
        output$arena <- renderPlot({
                xexp <- input$xexp
                yexp <- input$yexp
                xrange <- 10^xexp
                yrange <- 10^yexp
                xshift <- input$xshift
                yshift <- input$yshift
                xmin <- (-0.5+xshift)*xrange
                xmax <- (0.5+xshift)*xrange
                ymin <- (-0.5+yshift)*yrange
                ymax <- (0.5+yshift)*yrange
                xvals <- seq(xmin, xmax, by=10^(xexp-1))
                yvals <- seq(ymin, ymax, by=10^(yexp-1))
                df <- vals$points
                if (nrow(df) > 1) {
                        message(str(df))
                        vals$fit <- lm(y ~ x, data=df)
                        yh <- predict(vals$fit)
                        df <- mutate(df, yh = yh)
                } else {
                        vals$fit <- NULL
                }
                gg <- ggplot(df, aes(x, y)) + 
                        scale_x_continuous(limits = c(xmin, xmax)) +
                        scale_y_continuous(limits = c(ymin, ymax)) +
                        geom_point() +
 #                       geom_smooth(method="lm", color="red", linetype=0, fill='none') +
                        theme(legend.position="none")
                if (nrow(df) > 1) {
                        xs <- c(xmin, xmax)
                        ys <- predict(vals$fit, newdata=data.frame(x=xs))
                        gg <- gg + geom_segment(aes(x=xs[1], xend=xs[2], y=ys[1], yend=ys[2], color="red"))
                }
                gg
        })
        
        observeEvent(input$plot_dblclick, {
                res <- nearPoints(vals$points, input$plot_dblclick)
                vals$points <- anti_join(vals$points, res)
                vals$fit <- NULL
        })
        
        observeEvent(input$plot_click, {
                message(str(input$plot_click))
                res <- list(input$plot_click$x, input$plot_click$y)
                # message(vals$points)
                vals$points[nrow(vals$points)+1,] = res
                # message(res)
                vals$fit <- NULL
        })
        
        observeEvent(input$plot_brush, {
                res <- brushedPoints(vals$points, input$plot_brush)
                vals$points <- anti_join(vals$points, res)
        })
        output$coef = renderTable({
                if (!is.null(vals$fit)) {
                        tbl <- cbind(list('0', '1'), summary(vals$fit)$coef)
                        colnames(tbl)[1] <- 'beta'
                        tbl
                } else {
                        c()
                }
        })
        observeEvent(input$clear, {
                vals$points <- data.frame(x=numeric(), y=numeric())
                vals$fit <- NULL
        })
        
})
