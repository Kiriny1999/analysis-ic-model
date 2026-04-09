
server <- function(input, output, session) {
  lang <- reactiveVal("zh")
  
  observeEvent(input$toggle_lang, {
    lang(if (identical(lang(), "zh")) "en" else "zh")
  })
  
  tr <- function(zh, en) {
    if (identical(lang(), "zh")) zh else en
  }
  
  keep_value <- function(id, default = "") {
    val <- isolate(input[[id]])
    if (is.null(val)) default else val
  }
  
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
  
  observeEvent(input$number_pain_locations, {
    pain_locations <- parse_number(input$number_pain_locations)
    if (!is.na(pain_locations) && pain_locations == 0) {
      if (!identical(input$treat_pain, "无疼痛")) {
        updateSelectInput(session, "treat_pain", selected = "无疼痛")
      }
    }
  }, ignoreInit = TRUE)
  
  observeEvent(input$treat_pain, {
    pain_locations <- parse_number(input$number_pain_locations)
    if (!is.na(pain_locations) && pain_locations == 0 && !identical(input$treat_pain, "无疼痛")) {
      updateSelectInput(session, "treat_pain", selected = "无疼痛")
    }
  }, ignoreInit = TRUE)
  
  output$title_ui <- renderUI({
    titlePanel(tr("内在能力分数预测", "Intrinsic Capacity Score Prediction"))
  })

  output$lang_button_ui <- renderUI({
    absolutePanel(
      top = 10,
      right = 10,
      fixed = TRUE,
      draggable = FALSE,
      actionButton(
        "toggle_lang",
        if (identical(lang(), "zh")) "English" else "中文",
        class = "btn btn-outline-secondary"
      )
    )
  })
  
  output$sidebar_ui <- renderUI({
    tagList(
      h4(tr("请输入变量信息", "Enter Inputs")),
      tabsetPanel(
        tabPanel(
          tr("基本信息", "Basic Info"),
          textInput("age", tr("年龄（60-120）", "Age (60-120)"), value = keep_value("age", ""), placeholder = tr("例如：60", "e.g., 60")),
          selectInput(
            "literate",
            tr("识字能力", "Literacy"),
            choices = setNames(
              c("", "不识字", "识字"),
              c(tr("请选择", "Select"), tr("不识字", "Illiterate"), tr("识字", "Literate"))
            ),
            selected = keep_value("literate", "")
          ),
          selectInput(
            "education_level",
            tr("教育水平", "Education Level"),
            choices = setNames(
              c("", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11),
              c(
                tr("请选择", "Select"),
                tr("文盲", "Illiterate"),
                tr("未读完小学", "Did not finish primary school"),
                tr("私塾毕业", "Private school"),
                tr("小学毕业", "Primary school"),
                tr("初中毕业", "Middle school"),
                tr("高中毕业", "High school"),
                tr("中专毕业", "Vocational secondary school"),
                tr("大专毕业", "Junior college"),
                tr("本科毕业", "Bachelor's"),
                tr("硕士毕业", "Master's"),
                tr("博士毕业", "PhD")
              )
            ),
            selected = keep_value("education_level", "")
          ),
          selectInput(
            "martial_status",
            tr("婚姻状况", "Marital Status"),
            choices = setNames(
              c(
                "",
                "已婚与配偶一同居住",
                "已婚但配偶暂时不在一起居住",
                "已婚但配偶在外地工作",
                "离异",
                "丧偶",
                "从未结婚",
                "同居"
              ),
              c(
                tr("请选择", "Select"),
                tr("已婚与配偶一同居住", "Married (co-residing)"),
                tr("已婚但配偶暂时不在一起居住", "Married (not living together)"),
                tr("已婚但配偶在外地工作", "Married (spouse away for work)"),
                tr("离异", "Divorced"),
                tr("丧偶", "Widowed"),
                tr("从未结婚", "Never married"),
                tr("同居", "Cohabiting")
              )
            ),
            selected = keep_value("martial_status", "")
          ),
          selectInput(
            "address_urban_or_rural",
            tr("居住地类型", "Residence Type"),
            choices = setNames(
              c("", "主城区", "城乡结合部", "镇中心", "镇乡", "特殊区域", "乡中心", "村庄"),
              c(
                tr("请选择", "Select"),
                tr("主城区", "Urban core"),
                tr("城乡结合部", "Urban-rural fringe"),
                tr("镇中心", "Town center"),
                tr("镇乡", "Township"),
                tr("特殊区域", "Special area"),
                tr("乡中心", "Rural center"),
                tr("村庄", "Village")
              )
            ),
            selected = keep_value("address_urban_or_rural", "")
          )
        ),
        tabPanel(
          tr("健康状况", "Health"),
          textInput("hematocrit", tr("血红蛋白（>0）", "Hematocrit (>0)"), value = keep_value("hematocrit", ""), placeholder = tr("例如：130", "e.g., 130")),
          textInput("triglycerides", tr("甘油三酯（>0）", "Triglycerides (>0)"), value = keep_value("triglycerides", ""), placeholder = tr("例如：1.5", "e.g., 1.5")),
          textInput("uric_acid", tr("尿酸（>0）", "Uric acid (>0)"), value = keep_value("uric_acid", ""), placeholder = tr("例如：300", "e.g., 300")),
          textInput("waist_circumference", tr("腰围（>0）", "Waist circumference (>0)"), value = keep_value("waist_circumference", ""), placeholder = tr("例如：80", "e.g., 80")),
          textInput("number_chronic_disease", tr("慢性病数量（≥0）", "Chronic diseases (≥0)"), value = keep_value("number_chronic_disease", ""), placeholder = tr("例如：0", "e.g., 0")),
          textInput("year_diseases_arthritis", tr("关节炎患病年数（≥0）", "Years with arthritis (≥0)"), value = keep_value("year_diseases_arthritis", ""), placeholder = tr("例如：0", "e.g., 0")),
          textInput("number_pain_locations", tr("疼痛部位数量（≥0）", "Pain locations (≥0)"), value = keep_value("number_pain_locations", ""), placeholder = tr("例如：0", "e.g., 0")),
          selectInput(
            "treat_pain",
            tr("疼痛治疗情况", "Pain Treatment"),
            choices = setNames(
              c("", "无疼痛", "有疼痛且治疗", "有疼痛不治疗"),
              c(tr("请选择", "Select"), tr("无疼痛", "No pain"), tr("有疼痛且治疗", "Pain treated"), tr("有疼痛不治疗", "Pain not treated"))
            ),
            selected = keep_value("treat_pain", "")
          )
        ),
        tabPanel(
          tr("生活方式", "Lifestyle"),
          textInput("number_smoke", tr("吸烟数量（≥0）", "Cigarettes (≥0)"), value = keep_value("number_smoke", ""), placeholder = tr("例如：0", "e.g., 0")),
          textInput("year_smoke", tr("吸烟年数（≥0）", "Years of smoking (≥0)"), value = keep_value("year_smoke", ""), placeholder = tr("例如：0", "e.g., 0")),
          textInput("number_social_activities", tr("社会活动数量（≥0）", "Social activities (≥0)"), value = keep_value("number_social_activities", ""), placeholder = tr("例如：0", "e.g., 0")),
          textInput("number_grandchildren_great_grandchildren", tr("孙子女/重孙子女数量（≥0）", "Grandchildren (≥0)"), value = keep_value("number_grandchildren_great_grandchildren", ""), placeholder = tr("例如：0", "e.g., 0")),
          selectInput(
            "health_satisfaction",
            tr("健康满意度", "Health Satisfaction"),
            choices = setNames(
              c("", 1, 2, 3, 4, 5),
              c(
                tr("请选择", "Select"),
                tr("完全满意", "Completely satisfied"),
                tr("非常满意", "Very satisfied"),
                tr("一般满意", "Somewhat satisfied"),
                tr("不太满意", "Not very satisfied"),
                tr("完全不满意", "Not satisfied at all")
              )
            ),
            selected = keep_value("health_satisfaction", "")
          ),
          selectInput(
            "life_satisfaction",
            tr("生活满意度", "Life Satisfaction"),
            choices = setNames(
              c("", 1, 2, 3, 4, 5),
              c(
                tr("请选择", "Select"),
                tr("完全满意", "Completely satisfied"),
                tr("非常满意", "Very satisfied"),
                tr("一般满意", "Somewhat satisfied"),
                tr("不太满意", "Not very satisfied"),
                tr("完全不满意", "Not satisfied at all")
              )
            ),
            selected = keep_value("life_satisfaction", "")
          ),
          selectInput(
            "health_compared",
            tr("与两年前健康状况比较", "Health vs 2 Years Ago"),
            choices = setNames(
              c("", 1, 2, 3),
              c(tr("请选择", "Select"), tr("更好了", "Better"), tr("差不多", "About the same"), tr("更差了", "Worse"))
            ),
            selected = keep_value("health_compared", "")
          )
        )
      ),
      br(),
      actionButton("predict_btn", tr("开始预测", "Predict"), class = "btn-primary btn-lg", width = "100%")
    )
  })
  
  output$main_ui <- renderUI({
    tagList(
      h3(tr("预测结果", "Results")),
      verbatimTextOutput("prediction_result"),
      hr(),
      h4(tr("预测解释", "Explanation")),
      plotOutput("importance_plot", height = "520px"),
      hr(),
      h4(tr("内在能力分段标准（总分 15 分）", "IC Score Bands (Total 15)")),
      tableOutput("ic_standard_table")
    )
  })
  
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
      validate_number(age_num, tr("年龄", "Age"), min = 60, max = 120, integer = TRUE),
      validate_number(hematocrit_num, tr("血红蛋白", "Hematocrit"), min = 0, min_exclusive = TRUE),
      validate_number(triglycerides_num, tr("甘油三酯", "Triglycerides"), min = 0, min_exclusive = TRUE),
      validate_number(uric_acid_num, tr("尿酸", "Uric acid"), min = 0, min_exclusive = TRUE),
      validate_number(waist_circumference_num, tr("腰围", "Waist circumference"), min = 0, min_exclusive = TRUE),
      validate_number(number_chronic_disease_num, tr("慢性病数量", "Chronic diseases"), min = 0, integer = TRUE),
      validate_number(year_diseases_arthritis_num, tr("关节炎患病年数", "Years with arthritis"), min = 0, integer = TRUE),
      validate_number(number_pain_locations_num, tr("疼痛部位数量", "Pain locations"), min = 0, integer = TRUE),
      validate_number(number_smoke_num, tr("吸烟数量", "Cigarettes"), min = 0, integer = TRUE),
      validate_number(year_smoke_num, tr("吸烟年数", "Years of smoking"), min = 0, integer = TRUE),
      validate_number(number_social_activities_num, tr("社会活动数量", "Social activities"), min = 0, integer = TRUE),
      validate_number(number_grandchildren_num, tr("孙子女/重孙子女数量", "Grandchildren"), min = 0, integer = TRUE)
    )
    errors <- errors[!is.na(errors)]
    
    if (identical(input$literate, "")) errors <- c(errors, tr("未选择：识字能力", "Not selected: Literacy"))
    if (identical(input$education_level, "")) errors <- c(errors, tr("未选择：教育水平", "Not selected: Education level"))
    if (identical(input$martial_status, "")) errors <- c(errors, tr("未选择：婚姻状况", "Not selected: Marital status"))
    if (identical(input$address_urban_or_rural, "")) errors <- c(errors, tr("未选择：居住地类型", "Not selected: Residence type"))
    if (identical(input$treat_pain, "")) errors <- c(errors, tr("未选择：疼痛治疗情况", "Not selected: Pain treatment"))
    if (identical(input$health_satisfaction, "")) errors <- c(errors, tr("未选择：健康满意度", "Not selected: Health satisfaction"))
    if (identical(input$life_satisfaction, "")) errors <- c(errors, tr("未选择：生活满意度", "Not selected: Life satisfaction"))
    if (identical(input$health_compared, "")) errors <- c(errors, tr("未选择：与两年前健康状况比较", "Not selected: Health vs 2 years ago"))
    
    if (length(errors) > 0) {
      output$prediction_result <- renderText({
        paste0(
          tr("无法计算，请完善/修正以下项目：", "Cannot compute. Please fix the following:"),
          "\n",
          paste0("- ", errors, collapse = "\n")
        )
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
        segment <- tr("内在能力正常（14-15 分）", "Normal (14–15)")
        advice <- tr("总体良好，建议保持规律运动和均衡饮食。", "Overall good; maintain regular exercise and a balanced diet.")
      } else if (pred_capped >= 8) {
        segment <- tr("内在能力下降（8-13 分）", "Decline (8–13)")
        advice <- tr("提示下降，建议加强运动与营养管理并关注慢病控制。", "Potential decline; strengthen exercise/nutrition and monitor chronic conditions.")
      } else {
        segment <- tr("内在能力显著下降（0-7 分）", "Significant decline (0–7)")
        advice <- tr("提示显著下降，建议尽快进行老年综合评估并制定干预方案。", "Significant decline; seek a comprehensive geriatric assessment and an intervention plan.")
      }
      
      paste0(
        tr("预测的内在能力分数（总分 15 分）: ", "Predicted IC score (total 15): "),
        round(pred_capped, 2),
        "\n",
        tr("分段: ", "Band: "),
        segment,
        "\n",
        tr("建议: ", "Advice: "),
        advice
      )
    })

    # 7. Generate SHAP waterfall plot
    output$importance_plot <- renderPlot({
      # Calculate SHAP values for the single instance
      shap_obj <- shapviz(xgb_model, X_pred = input_matrix)
      
      current_cols <- colnames(shap_obj)
      label_map <- if (identical(lang(), "zh")) feature_labels else feature_labels_en
      new_cols <- label_map[current_cols]
      new_cols[is.na(new_cols)] <- current_cols[is.na(new_cols)]
      colnames(shap_obj) <- new_cols
      
      sv_waterfall(shap_obj, row_id = 1) +
        ggtitle(tr("SHAP 瀑布图（个体预测解释）", "SHAP Waterfall (Individual Explanation)")) +
        theme(text = element_text(size = 14, family = "noto_sans"))
    }, width = 900, height = 520)
  })

  output$ic_standard_table <- renderTable({
    if (identical(lang(), "zh")) {
      data.frame(
        `分段（总分 15 分）` = c("14-15", "8-13", "0-7"),
        `提示` = c("内在能力正常", "内在能力下降", "内在能力显著下降"),
        check.names = FALSE
      )
    } else {
      data.frame(
        `Band (Total 15)` = c("14–15", "8–13", "0–7"),
        `Meaning` = c("Normal", "Decline", "Significant decline"),
        check.names = FALSE
      )
    }
  }, striped = TRUE, bordered = TRUE, hover = TRUE, spacing = "s")
  
  # Initial placeholder plot or empty
  output$importance_plot <- renderPlot({
    # Optional: Display a message or global importance before prediction
    importance_matrix <- xgb.importance(model = xgb_model)
    
    label_map <- if (identical(lang(), "zh")) feature_labels else feature_labels_en
    importance_matrix$Feature <- label_map[importance_matrix$Feature]
    
    # Plot all features (remove top_n limit)
    # Convert to ggplot for better font control
    importance_df <- as.data.frame(importance_matrix)
    ggplot(importance_df, aes(x = reorder(Feature, Gain), y = Gain)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      coord_flip() +
      labs(
        title = tr("全局变量重要性", "Global Feature Importance"),
        x = tr("特征", "Feature"),
        y = tr("增益", "Gain")
      ) +
      theme_minimal() +
      theme(text = element_text(size = 14, family = "noto_sans"))
  }, width = 900, height = 520)
}
