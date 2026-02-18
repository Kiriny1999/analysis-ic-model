library(shiny)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  titlePanel("内在能力分数预测 (Intrinsic Capacity Score Prediction)"),
  
  sidebarLayout(
    sidebarPanel(
      width = 4,
      h4("请输入变量信息"),
      
      tabsetPanel(
        tabPanel("基本信息",
          numericInput("age", "年龄 (Age) (范围: 60-120)", value = 60, min = 60, max = 120),
          selectInput("literate", "识字能力 (Literate)", 
                      choices = c("不识字", "识字")),
          selectInput("education_level", "教育水平 (Education Level)", 
                      choices = c("文盲" = 1, "未读完小学" = 2, "私塾毕业" = 3, 
                                  "小学毕业" = 4, "初中毕业" = 5, "高中毕业" = 6, 
                                  "中专毕业" = 7, "大专毕业" = 8, "本科毕业" = 9, 
                                  "硕士毕业" = 10, "博士毕业" = 11)),
          selectInput("martial_status", "婚姻状况 (Martial Status)", 
                      choices = c("已婚与配偶一同居住", "已婚但配偶暂时不在一起居住", 
                                  "已婚但配偶在外地工作", "离异", "丧偶", "从未结婚", "同居")),
          selectInput("address_urban_or_rural", "居住地类型 (Address Type)", 
                      choices = c("主城区", "城乡结合部", "镇中心", "镇乡", 
                                  "特殊区域", "乡中心", "村庄"))
        ),
        
        tabPanel("健康状况",
          numericInput("hematocrit", "血红蛋白 (Hematocrit, g/L) (范围: >0)", value = 130, min = 0),
          numericInput("triglycerides", "甘油三酯 (Triglycerides) (范围: >0)", value = 1.5, min = 0),
          numericInput("uric_acid", "尿酸 (Uric Acid) (范围: >0)", value = 300, min = 0),
          numericInput("waist_circumference", "腰围 (Waist Circumference, cm) (范围: >0)", value = 80, min = 0),
          numericInput("number_chronic_disease", "慢性病数量 (Number of Chronic Diseases) (范围: ≥0)", value = 0, min = 0),
          numericInput("year_diseases_arthritis", "关节炎患病年数 (Years of Arthritis) (范围: ≥0)", value = 0, min = 0),
          numericInput("number_pain_locations", "疼痛部位数量 (Number of Pain Locations) (范围: ≥0)", value = 0, min = 0),
          selectInput("treat_pain", "疼痛治疗情况 (Pain Treatment)", 
                      choices = c("无疼痛", "有疼痛且治疗", "有疼痛不治疗"))
        ),
        
        tabPanel("生活方式",
          numericInput("number_smoke", "吸烟数量 (Number of Smokes) (范围: ≥0)", value = 0, min = 0),
          numericInput("year_smoke", "吸烟年数 (Years of Smoking) (范围: ≥0)", value = 0, min = 0),
          numericInput("number_social_activities", "社会活动数量 (Number of Social Activities) (范围: ≥0)", value = 0, min = 0),
          numericInput("number_grandchildren_great_grandchildren", "孙子女/重孙子女数量 (Number of Grandchildren) (范围: ≥0)", value = 0, min = 0),
          numericInput("health_satisfaction", "健康满意度 (Health Satisfaction) (范围: 1-5)", value = 3, min = 1, max = 5), # Assuming 1-5 scale
          numericInput("life_satisfaction", "生活满意度 (Life Satisfaction) (范围: 1-5)", value = 3, min = 1, max = 5), # Assuming 1-5 scale
          numericInput("health_compared", "健康状况比较 (Health Compared) (范围: 1-5)", value = 3, min = 1, max = 5) # Assuming scale
        )
      ),
      
      br(),
      actionButton("predict_btn", "开始预测 (Predict)", class = "btn-primary btn-lg", width = "100%")
    ),
    
    mainPanel(
      width = 8,
      h3("预测结果"),
      verbatimTextOutput("prediction_result"),
      
      hr(),
      h4("预测解释 (Prediction Explanation)"),
      plotOutput("importance_plot")
    )
  )
)
