#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(randomForest)
library(e1071)
library(gbm)
library(plyr)
library(rpart)
library(datasets)
library(PerformanceAnalytics)
library(arm)
library(ggplot2)
library(pROC)
library(ROCR)
library(earth)

shinyServer(function(input, output) {
  
  choosemodel <- reactive({
                        switch(input$selectmodel,
                        "CART" = "rpart2",
                        "Support Vector Machine" = "svmLinear2",
                        "earth" = "earth",
                        "Bayesian Generalized Linear" = "bayesglm",
                        "Random forest" = "rf") })
  
  output$output1 <- renderPrint({
    set.seed(100)
    TrainData_trainset <- createDataPartition(as.factor(infert$case), p=input$nTrainData/100, list = FALSE)
    training_dataset <- infert[TrainData_trainset, ]
    validation_dataset <- infert[-TrainData_trainset, ]
    
    control <- trainControl(method="cv", number=input$nfold)

   if(input$Prepros){
    trainmodel <- train(as.factor(case) ~ ., data=training_dataset, method=choosemodel(), trControl=control, preProc=c("center", "scale"))
   } else {
    trainmodel <- train(as.factor(case) ~ ., data=training_dataset, method=choosemodel(), trControl=control)
   }
    
    model_predict <- predict(trainmodel, newdata=validation_dataset)
    cmatrix <- confusionMatrix(validation_dataset$case, model_predict)
    cmatrix
    
  })
  
  output$output2 <- renderPrint({
    set.seed(100)
    TrainData_trainset <- createDataPartition(as.factor(infert$case), p=input$nTrainData/100, list = FALSE)
    training_dataset <- infert[TrainData_trainset, ]
    validation_dataset <- infert[-TrainData_trainset, ]
    
    control <- trainControl(method="cv", number=input$nfold)
    
    if(input$Prepros){
      trainmodel <- train(as.factor(case) ~ ., data=training_dataset, method=choosemodel(), trControl=control, preProc=c("center", "scale"))
    } else {
      trainmodel <- train(as.factor(case) ~ ., data=training_dataset, method=choosemodel(), trControl=control)
    }
    
    varImp(trainmodel)
  })
  
  output$output3 <- renderPlot({
    set.seed(100)
    TrainData_trainset <- createDataPartition(as.factor(infert$case), p=input$nTrainData/100, list = FALSE)
    training_dataset <- infert[TrainData_trainset, ]
    validation_dataset <- infert[-TrainData_trainset, ]
    
    control <- trainControl(method="cv", number=input$nfold)
    
    if(input$Prepros){
      trainmodel <- train(as.factor(case) ~ ., data=training_dataset, method=choosemodel(), trControl=control, preProc=c("center", "scale"))
    } else {
      trainmodel <- train(as.factor(case) ~ ., data=training_dataset, method=choosemodel(), trControl=control)
    }
    
    model_predict <- predict(trainmodel, newdata=validation_dataset)
    plot(roc(validation_dataset$case, as.numeric(model_predict)))
    #ROCR::plot(trainmodel)
  })
})