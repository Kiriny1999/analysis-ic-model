
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

    # 7. Generate SHAP waterfall plot
    output$importance_plot <- renderPlot({
      # Calculate SHAP values for the single instance
      shap_obj <- shapviz(xgb_model, X_pred = input_matrix)
      
      # Rename columns in shap_obj to Chinese labels
      # Note: shapviz object structure usually allows direct column renaming or via colnames()
      # Depending on version, we might need to be careful.
      # Safest way: iterate and replace if match found
      current_cols <- colnames(shap_obj)
      new_cols <- feature_labels[current_cols]
      # If any NA (no match), keep original name
      new_cols[is.na(new_cols)] <- current_cols[is.na(new_cols)]
      colnames(shap_obj) <- new_cols
      
      # Plot waterfall chart for the first (and only) observation
      sv_waterfall(shap_obj, row_id = 1) +
        ggtitle("SHAP 瀑布图 (个体预测解释)") +
        theme(text = element_text(size = 14, family = "noto_sans"))
    })
  })
  
  # Initial placeholder plot or empty
  output$importance_plot <- renderPlot({
    # Optional: Display a message or global importance before prediction
    importance_matrix <- xgb.importance(model = xgb_model)
    
    # Map feature names to Chinese labels
    importance_matrix$Feature <- feature_labels[importance_matrix$Feature]
    
    # Plot all features (remove top_n limit)
    # Convert to ggplot for better font control
    importance_df <- as.data.frame(importance_matrix)
    ggplot(importance_df, aes(x = reorder(Feature, Gain), y = Gain)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      coord_flip() +
      labs(title = "全局变量重要性 (Global Feature Importance)", x = "特征 (Feature)", y = "增益 (Gain)") +
      theme_minimal() +
      theme(text = element_text(size = 14, family = "noto_sans"))
  })
}
