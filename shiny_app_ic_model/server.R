
server <- function(input, output) {
  
  observeEvent(input$predict_btn, {
    
    # 1. Create a named vector with all features initialized to 0
    input_data <- numeric(length(feature_names))
    names(input_data) <- feature_names
    
    # 2. Fill numeric variables
    input_data["age"] <- input$age
    input_data["hematocrit"] <- input$hematocrit
    input_data["number_pain_locations"] <- input$number_pain_locations
    input_data["number_grandchildren_great_grandchildren"] <- input$number_grandchildren_great_grandchildren
    input_data["waist_circumference"] <- input$waist_circumference
    input_data["education_level"] <- as.numeric(input$education_level)
    input_data["triglycerides"] <- input$triglycerides
    input_data["uric_acid"] <- input$uric_acid
    input_data["year_smoke"] <- input$year_smoke
    input_data["health_satisfaction"] <- input$health_satisfaction
    input_data["number_chronic_disease"] <- input$number_chronic_disease
    input_data["year_diseases_arthritis"] <- input$year_diseases_arthritis
    input_data["health_compared"] <- input$health_compared
    input_data["number_social_activities"] <- input$number_social_activities
    input_data["life_satisfaction"] <- input$life_satisfaction
    input_data["number_smoke"] <- input$number_smoke
    
    # 3. Fill categorical variables (One-Hot Encoding)
    
    # treat_pain
    col_name <- paste0("treat_pain_", input$treat_pain)
    if (col_name %in% feature_names) {
      input_data[col_name] <- 1
    }
    
    # address_urban_or_rural
    col_name <- paste0("address_urban_or_rural_", input$address_urban_or_rural)
    if (col_name %in% feature_names) {
      input_data[col_name] <- 1
    }
    
    # literate
    col_name <- paste0("literate_", input$literate)
    if (col_name %in% feature_names) {
      input_data[col_name] <- 1
    }
    
    # martial_status
    col_name <- paste0("martial_status_", input$martial_status)
    if (col_name %in% feature_names) {
      input_data[col_name] <- 1
    }
    
    # 4. Convert to matrix
    input_matrix <- matrix(input_data, nrow = 1)
    colnames(input_matrix) <- feature_names
    
    # 5. Predict
    prediction <- predict(xgb_model, input_matrix)
    
    # 6. Output result
    output$prediction_result <- renderText({
      paste0("预测的内在能力分数 (Predicted Intrinsic Capacity Score): ", round(prediction, 4))
    })
  })
  
  # Plot feature importance
  output$importance_plot <- renderPlot({
    importance_matrix <- xgb.importance(model = xgb_model)
    xgb.plot.importance(importance_matrix, top_n = 10, main = "Top 10 Feature Importance")
  })
}
