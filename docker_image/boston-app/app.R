#setwd("/home/msc1/Desktop/R_lab/Learning_R_programming")

library(shiny)
library(shinythemes)
ui <- fluidPage(theme = shinytheme("cyborg"), 
                tags$style((HTML("
                                 body{
                                 min-height:100%; 
                                 postion:fixed; 
                                 overflow:hidden;
                                 }
                                 .sidepanel{
                                 overflow-y:auto; 
                                 max-height:90vh; 
                                 position:relative; 
                                 min-width:380px; 
                                 scrollbar-width:0px;
                                 }
                                 .sidepanel::-webkit-scrollbar {
                                      display: none;
                                  }
                                 .pred-button{
                                  padding:50px;
                                 }
                                 .pred-text{
                                 margin: auto;
                                 margin-top:16px;
                                 padding: 5px;
                                 font-size:60px;
                                 }
                                 .main{
                                  margin: auto;
                                  margin-top:20vh;
                                  width: 60%; 
                                  padding: 5px;
                                  text-align:center;
                                 }
                                 "))),
                
                # App title
                titlePanel(h5("🏡 Boston Housing Price Prediction ")),
                
                # Sidebar with a slider input for number of bins 
                sidebarLayout(
                  sidebarPanel(class="sidepanel",
                               p(style="text-align:center; font-size:15.5px; padding-bottom:8px","⬩ Feature Inputs ⬩"),
                               fluidRow(
                                 column(12, p(style="font-weight:bold", "‣ Beside River Charles ?"), checkboxInput("CHAS",  "Yes", value = FALSE)),
                                 
                                 column(12, 
                                        sliderInput("ZN",("‣ Proportion of residential land zoned for lots :"),
                                                    min = 0, max =30, value = 11, 0.5)),
                                 column(12, 
                                        sliderInput("NOX",("‣ Nitric Oxide concentration (parts per 10 million) :"),
                                                    min = 0, max = 0.9, value = 0.5, 0.001)),
                                 column(12, 
                                        sliderInput("RM",("‣ Average number of rooms per dwelling :"),
                                                    min = 3, max = 9, value = 6, 0.001)),
                                 column(12, 
                                        sliderInput("DIS",("‣ Weighted distances to five Boston employment centres :"),
                                                    min = 1, max = 13, value = 3, 0.001)),
                                 column(12, 
                                        sliderInput("PTRATIO",("‣ Pupil-teacher ratio by town :"),
                                                    min = 12, max = 22, value = 18,0.1)),
                                 column(12, 
                                        sliderInput("B",("‣ Proportion of blacks :"),
                                                    min = 0, max = 0.63, value = 0.5, 0.01)),
                                 column(12, 
                                        sliderInput("LSTAT",("‣ % Lower status of the population :"),
                                                    min = 0, max = 38, value = 12,0.01)),
                                 
                                 
                               )),
                  
                  
                  # Show a plot of the generated distribution
                  mainPanel(
                    div(class="main",
                        div(style="font-size:25px; padding: 5px;", "Predicted Median Price of Houses "),
                        h3(class="pred-text",textOutput("predicted")),
                        div(class="pred-button",submitButton("Predict")))
                  )
                )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  model <- readRDS("./model.rds")
  output$Inputs <- renderText({paste("proportion of lots: ", input$ZN, " Beside Charles? :",input$CHAS, "\nProportion of NO :",input$NOX, input$RM,input$DIS,input$PTRATIO, input$B, input$LSTAT)})
  data <- reactive({  data.frame(ZN=input$ZN,CHAS=input$CHAS+0, NOX=input$NOX, RM=input$RM,DIS=input$DIS,PTRATIO=input$PTRATIO, B=1000*(input$B)^2, LSTAT=input$LSTAT)  })
  pred <- reactive({ predict(model, data() ) })
  output$predicted <- renderText({ paste("$",round(pred(),3),"k")})
}

# Run the application 
shinyApp(ui = ui, server = server)

