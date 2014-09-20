library(shiny)
library(UsingR)
require(graphics)
data(galton)
data(mtcars)
data(iris)

runKMeans <- 
        function(data,input)
        {
                kmeans( x = data,
                       algorithm = input$slAlgorithm,
                       centers = as.numeric(input$numCenters),
                       nstart = as.numeric(input$numInitial)
                       )
        }

plotResult <-
        function(data, clusters, showCenters)
        {
                plot(data, col = clusters$cluster)
                if(showCenters==TRUE)
                {
                        points(clusters$centers, col = 1:dim(clusters$centers)[1], pch = 8)
                }               
        }

shinyServer(
        function(input, output) {
                
                # get variables to display dynamically on the drop downs
                vars <- reactive({
                        if(input$slDataset=='gal')
                        {
                                colnames(galton)
                        }
                        else if(input$slDataset=='iris')
                        {
                                colnames(iris)
                        }
                        else
                        {
                                colnames(mtcars)
                        }
                })
      
                output$dataVarX <- renderUI({ selectInput("varsX", "Choose variable X", vars())})
                output$dataVarY <- renderUI({ selectInput("varsY", "Choose variable Y", vars())})
                
                # get data selected
                dataSelected <-reactive({
                        if(input$slDataset=='gal')
                        {
                               galton[, c(input$varsX, input$varsY)]
                        }
                        else if(input$slDataset=='iris')
                        {
                                iris[, c(input$varsX, input$varsY)]
                        }
                        else
                        {
                                mtcars[, c(input$varsX, input$varsY)]
                        }
                })
                
                # run k-Means depending on the input
                result <- reactive({ if(input$submit >= 1){runKMeans(dataSelected(),input)}})
                
                # create plot from k-Means result
                resultPlot <- reactive({ if(input$submit >= 1){plotResult(dataSelected(),result(),input$chkShowCenters)}})
                
                # return outputs
                resultSS <- reactive({(result()$betweenss/result()$totss) * 100})
                
                output$numClusters <- renderText({dim(result()$centers)[1]})
                output$clusterSize <- renderText({result()$size})
                output$clusterWSS <- renderText({result()$withinss})
                output$clusterSS <- renderText({resultSS()})
                output$clustersPlot <- renderPlot({resultPlot()})
        }
)