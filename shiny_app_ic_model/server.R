
server <- function(input, output) {
  parse_number <- function(x) {
    if (is.null(x)) {
      return(NA_real_)
    }
    x <- trimws(as.character(x))
    if (identical(x, "")) {
      return(NA_real_)
    }
    suppressWarnings(as.numeric(x))
  }
  
  validate_number <- function(value, label, min = NULL, max = NULL, min_exclusive = FALSE, integer = FALSE) {
    if (is.na(value)) {
      return(paste0("未填写：", label))
    }
    if (!is.null(min)) {
      if (min_exclusive) {
        if (!(value > min)) {
          return(paste0(label, " 超出范围（应 > ", min, "）"))
        }
      } else if (value < min) {
        return(paste0(label, " 超出范围（应 ≥ ", min, "）"))
      }
    }
    if (!is.null(max) && value > max) {
      return(paste0(label, " 超出范围（应 ≤ ", max, "）"))
    }
    if (integer && value != floor(value)) {
      return(paste0(label, " 需为整数"))
    }
    NULL
  }
  
  observeEvent(input$predict_btn, {
    errors <- character(0)
    
    age_num <- parse_number(input$age)
    hematocrit_num <- parse_number(input$hematocrit)
    triglycerides_num <- parse_number(input$triglycerides)
    uric_acid_num <- parse_number(input$uric_acid)
    waist_circumference_num <- parse_number(input$waist_circumference)
    number_chronic_disease_num <- parse_number(input$number_chronic_disease)
    year_diseases_arthritis_num <- parse_number(input$year_diseases_arthritis)
    number_pain_locations_num <- parse_number(input$number_pain_locations)
    number_smoke_num <- parse_number(input$number_smoke)
    year_smoke_num <- parse_number(input$year_smoke)
    number_social_activities_num <- parse_number(input$number_social_activities)
    number_grandchildren_num <- parse_number(input$number_grandchildren_great_grandchildren)
    
    errors <- c(
      errors,
      validate_number(age_num, "年龄", min = 60, max = 120, integer = TRUE),
      validate_number(hematocrit_num, "血红蛋白", min = 0, min_exclusive = TRUE),
      validate_number(triglycerides_num, "甘油三酯", min = 0, min_exclusive = TRUE),
      validate_number(uric_acid_num, "尿酸", min = 0, min_exclusive = TRUE),
      validate_number(waist_circumference_num, "腰围", min = 0, min_exclusive = TRUE),
      validate_number(number_chronic_disease_num, "慢性病数量", min = 0, integer = TRUE),
      validate_number(year_diseases_arthritis_num, "关节炎患病年数", min = 0, integer = TRUE),
      validate_number(number_pain_locations_num, "疼痛部位数量", min = 0, integer = TRUE),
      validate_number(number_smoke_num, "吸烟数量", min = 0, integer = TRUE),
      validate_number(year_smoke_num, "吸烟年数", min = 0, integer = TRUE),
      validate_number(number_social_activities_num, "社会活动数量", min = 0, integer = TRUE),
      validate_number(number_grandchildren_num, "孙子女/重孙子女数量", min = 0, integer = TRUE)
    )
    errors <- errors[!is.na(errors)]
    
    if (identical(input$literate, "")) errors <- c(errors, "未选择：识字能力")
    if (identical(input$education_level, "")) errors <- c(errors, "未选择：教育水平")
    if (identical(input$martial_status, "")) errors <- c(errors, "未选择：婚姻状况")
    if (identical(input$address_urban_or_rural, "")) errors <- c(errors, "未选择：居住地类型")
    if (identical(input$treat_pain, "")) errors <- c(errors, "未选择：疼痛治疗情况")
    if (identical(input$health_satisfaction, "")) errors <- c(errors, "未选择：健康满意度")
    if (identical(input$life_satisfaction, "")) errors <- c(errors, "未选择：生活满意度")
    if (identical(input$health_compared, "")) errors <- c(errors, "未选择：与两年前健康状况比较")
    
    if (length(errors) > 0) {
      output$prediction_result <- renderText({
        paste0("无法计算，请完善/修正以下项目：\n", paste0("- ", errors, collapse = "\n"))
      })
      return(NULL)
    }

    health_satisfaction_numeric <- as.numeric(input$health_satisfaction)
    life_satisfaction_numeric <- as.numeric(input$life_satisfaction)
    health_compared_numeric <- as.numeric(input$health_compared)
    
    # 1. Create a named vector with all features initialized to 0
    input_data <- numeric(length(feature_names))
    names(input_data) <- feature_names
    
    # 2. Fill numeric variables
    input_data["age"] <- age_num
    input_data["hematocrit"] <- hematocrit_num
    input_data["number_pain_locations"] <- number_pain_locations_num
    input_data["number_grandchildren_great_grandchildren"] <- number_grandchildren_num
    input_data["waist_circumference"] <- waist_circumference_num
    input_data["education_level"] <- as.numeric(input$education_level)
    input_data["triglycerides"] <- triglycerides_num
    input_data["uric_acid"] <- uric_acid_num
    input_data["year_smoke"] <- year_smoke_num
    input_data["health_satisfaction"] <- health_satisfaction_numeric
    input_data["number_chronic_disease"] <- number_chronic_disease_num
    input_data["year_diseases_arthritis"] <- year_diseases_arthritis_num
    input_data["health_compared"] <- health_compared_numeric
    input_data["number_social_activities"] <- number_social_activities_num
    input_data["life_satisfaction"] <- life_satisfaction_numeric
    input_data["number_smoke"] <- number_smoke_num
    
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
      pred <- as.numeric(prediction)
      pred_capped <- max(0, min(15, pred))
      
      if (pred_capped >= 14) {
        segment <- "内在能力正常（14-15 分）"
        advice <- "总体良好，建议保持规律运动和均衡饮食。"
      } else if (pred_capped >= 8) {
        segment <- "内在能力下降（8-13 分）"
        advice <- "提示下降，建议加强运动与营养管理并关注慢病控制。"
      } else {
        segment <- "内在能力显著下降（0-7 分）"
        advice <- "提示显著下降，建议尽快进行老年综合评估并制定干预方案。"
      }
      
      paste0(
        "预测的内在能力分数（总分15分）: ", round(pred_capped, 2), "\n",
        "分段: ", segment, "\n",
        "建议: ", advice
      )
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

  output$ic_standard_table <- renderTable({
    data.frame(
      `分段（总分 15 分）` = c("14-15", "8-13", "0-7"),
      `提示` = c("内在能力正常", "内在能力下降", "内在能力显著下降"),
      check.names = FALSE
    )
  }, striped = TRUE, bordered = TRUE, hover = TRUE, spacing = "s")
  
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
