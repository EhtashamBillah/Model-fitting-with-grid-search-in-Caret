##############################################
# A. extreme gradient boosting trees
#############################################
# setting control
control <- trainControl(method="repeatedcv",
                        number = 10,
                        repeats = 10,
                        classProbs = T,
                        summaryFunction = twoClassSummary)

#setting grid
xgbGrid <- expand.grid(nrounds = c(20,40,60,80),
                       max_depth = c(10,15,20,25),
                       eta = c(0.1,0.2,0.4),
                       gamma = 0,
                       colsample_bytree = 0.7,
                       min_child_weight = 1,
                       subsample = c(0.6,0.8,1))

# fitting model through grid search
model_xgb<- train(form = Target ~.,
                  data = new_train_data,
                  method = 'xgbTree',
                  preProcess=c("center","scale"),
                  metric = "ROC",
                  trControl = control,
                  tuneGrid = xgbGrid)



# optimal hyperparameter
model_xgb$bestTune
#performance grid
model_xgb
# visualization
plot(model_xgb)
# variable importance
importance_xgb <- varImp(model_xgb)
plot(importance_xgb,col="#8470ff",main="Variable Importance (Extreme Gradient Boosting)")


# prediction
xgb_pred <- predict(model_xgb,newdata = test_data[,-18]) 
xgb_prob <- predict(model_xgb,newdata = test_data[,-18],type = "prob") 