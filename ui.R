shinyUI(
        pageWithSidebar(
        headerPanel('Shiny-up Clustering'),
        sidebarPanel(
                h3('Lets give k-Means a shot!'),
                p('For this application we will run a simple, well-known clustering method, the K-Means.
                  This aims at partitioning the points into k groups such that the sum of squares from the
                  points to the assigned cluster centers is minimised.We will keep it down to two dimensions.
                  (see ?kmeans for more details)'),
                selectInput("slAlgorithm", "Algorithm:",
                            c("Hartigan-Wong" = "Hartigan-Wong",
                              "Lloyd" = "Lloyd",
                              "MacQueen" = "MacQueen")),
                selectInput("slDataset", "Data set:",
                            c("Iris" = "iris",
                              "Galton" = "gal",
                              "MT cars" = "mtc"
                              )),
                uiOutput("dataVarX"),
                uiOutput("dataVarY"),
                numericInput("numCenters", "No. clusters (k):", 5, min = 1, max = 100),
                numericInput("numInitial", "No. starting centers:", 25, min = 1, max = 100),
                checkboxInput('chkShowCenters','Show cluster centers?',TRUE),
                actionButton('submit','Go clustering!'),
                p(),
                p('The data and the results are for demonstration purposes ONLY. No analysis has been or was intented to be conducted.'),
                width = 6
        ),
        mainPanel(
                h3('Clustering results'),
                p('Number of clusters created:'),
                verbatimTextOutput('numClusters'),
                p('Points assigned to each cluster:'),
                verbatimTextOutput('clusterSize'),
                p('Within cluster sum of squares by cluster:'),
                verbatimTextOutput('clusterWSS'),
                p('Between-cluster sum of squares / Total sum of squares:'),
                verbatimTextOutput('clusterSS'),
                plotOutput('clustersPlot'),
                width = 6
        )
))
