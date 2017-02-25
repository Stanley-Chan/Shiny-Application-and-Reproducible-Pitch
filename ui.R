#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(
  
  navbarPage("Model Simulator",
             
      tabPanel("About",
        h2("Model Simulator"),
        hr(),
        h3("Description"),
        helpText("The model simulator help to understand some of the tuning parameters in machine learning.",
                 "The Tuning parametets included selection of type of model, K-fold cross validation,",
                 "split of the train data set and test dataset, and pre-processing. Tuning the parameters will",
                 "produce different prediction accuracy, variable importance and ROC curve plot. Results from the simulator",
                 "can help you to choose the most effective parameter for your model."),
        h3("Dataset"),
        p("We are using dataset 'infert' from 'datasets' library with 248 observations and 8 variables."),
        h3("Inputs - Model Parameters"),
        p("1. Train Model (Drop Down List) : There are 5 different machine learning algorithm - CART, Support Vector Machine,",
          "earth, Bayesian Generalized Linear and Random forest."),
        p("2. K-Fold Cross Validation (Slider) : Increasing the number of fold can help to improve or reduce the",
          "effectiveness of the model."),
        p("3. Split Of Train Dataset (Slider) : Increasing the number of split train dataset can help to improve or reduce the",
          "effectiveness of the model."),
        p("4. Pre-Processing (Checkbox) : Select pre-processing can help to improve or reduce the",
          "effectiveness of the model."),
        h3("Outputs - Charts and Plots"),
        p("1. Confusion Matrix : The matrix will provides all the information on the accuracy of your model,",
          "confusion matrix, sensitivity, specificity and etc."),
        p("2. Variable Importance : The top variable importance will help you to fine tune and define your new model",
          "with selection of the top variables for your model."),
        p("3. ROC Curve Plot : ROC curve will help you to understand whether your model will produce more accurate",
          "prediction or it is not.")
      ),
          
      tabPanel("Simulator",
          fluidPage(
            titlePanel("Model Simulator"),
             
              sidebarLayout(
                sidebarPanel(
                  selectInput("selectmodel", "Train Model", 
                            choices = c("CART","Support Vector Machine", "earth",
                                        "Bayesian Generalized Linear","Random forest" )),
              
                  sliderInput("nfold", "K-Fold Cross Validation",
                          3, 10, value = 3),
                  sliderInput("nTrainData", "Split Of Train Data Set",
                          60, 90, value = 60, step = 10),
                  checkboxInput("Prepros", "Pre-processing", 
                            value = FALSE)
                  #checkboxInput("show_LRAnalysis", "Show/Hide Linear Regression Analysis", 
                            #value = TRUE)
                ),
            
            
              mainPanel(
                style = "border: 1px solid silver;", 
                style = "font-family: 'calibri';",
                
                fluidRow(
                
                  column(6, align="center", h1("Confusion Matrix")),
                  column(6, align="center", h1("Variable Importance"))
                ),
                
                fluidRow(
                
                  column(6, verbatimTextOutput("output1")),
                  column(6, verbatimTextOutput("output2"))
                ),
                
                h2(align="center", "ROC (Receiver Operating Characteristic) Curve Plot"),
                plotOutput("output3")
              )
             )
      ))
    
))