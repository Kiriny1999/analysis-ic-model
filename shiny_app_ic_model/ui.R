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
          textInput("age", "年龄 (Age) (范围: 60-120)", value = "", placeholder = "例如：60"),
          selectInput(
            "literate",
            "识字能力 (Literate)",
            choices = c("请选择" = "", "不识字" = "不识字", "识字" = "识字"),
            selected = ""
          ),
          selectInput(
            "education_level",
            "教育水平 (Education Level)",
            choices = c(
              "请选择" = "",
              "文盲" = 1, "未读完小学" = 2, "私塾毕业" = 3,
              "小学毕业" = 4, "初中毕业" = 5, "高中毕业" = 6,
              "中专毕业" = 7, "大专毕业" = 8, "本科毕业" = 9,
              "硕士毕业" = 10, "博士毕业" = 11
            ),
            selected = ""
          ),
          selectInput(
            "martial_status",
            "婚姻状况 (Martial Status)",
            choices = c(
              "请选择" = "",
              "已婚与配偶一同居住" = "已婚与配偶一同居住",
              "已婚但配偶暂时不在一起居住" = "已婚但配偶暂时不在一起居住",
              "已婚但配偶在外地工作" = "已婚但配偶在外地工作",
              "离异" = "离异",
              "丧偶" = "丧偶",
              "从未结婚" = "从未结婚",
              "同居" = "同居"
            ),
            selected = ""
          ),
          selectInput(
            "address_urban_or_rural",
            "居住地类型 (Address Type)",
            choices = c(
              "请选择" = "",
              "主城区" = "主城区",
              "城乡结合部" = "城乡结合部",
              "镇中心" = "镇中心",
              "镇乡" = "镇乡",
              "特殊区域" = "特殊区域",
              "乡中心" = "乡中心",
              "村庄" = "村庄"
            ),
            selected = ""
          )
        ),
        
        tabPanel("健康状况",
          textInput("hematocrit", "血红蛋白 (Hematocrit, g/L) (范围: >0)", value = "", placeholder = "例如：130"),
          textInput("triglycerides", "甘油三酯 (Triglycerides) (范围: >0)", value = "", placeholder = "例如：1.5"),
          textInput("uric_acid", "尿酸 (Uric Acid) (范围: >0)", value = "", placeholder = "例如：300"),
          textInput("waist_circumference", "腰围 (Waist Circumference, cm) (范围: >0)", value = "", placeholder = "例如：80"),
          textInput("number_chronic_disease", "慢性病数量 (Number of Chronic Diseases) (范围: ≥0)", value = "", placeholder = "例如：0"),
          textInput("year_diseases_arthritis", "关节炎患病年数 (Years of Arthritis) (范围: ≥0)", value = "", placeholder = "例如：0"),
          textInput("number_pain_locations", "疼痛部位数量 (Number of Pain Locations) (范围: ≥0)", value = "", placeholder = "例如：0"),
          selectInput(
            "treat_pain",
            "疼痛治疗情况 (Pain Treatment)",
            choices = c("请选择" = "", "无疼痛" = "无疼痛", "有疼痛且治疗" = "有疼痛且治疗", "有疼痛不治疗" = "有疼痛不治疗"),
            selected = ""
          )
        ),
        
        tabPanel("生活方式",
          textInput("number_smoke", "吸烟数量 (Number of Smokes) (范围: ≥0)", value = "", placeholder = "例如：0"),
          textInput("year_smoke", "吸烟年数 (Years of Smoking) (范围: ≥0)", value = "", placeholder = "例如：0"),
          textInput("number_social_activities", "社会活动数量 (Number of Social Activities) (范围: ≥0)", value = "", placeholder = "例如：0"),
          textInput("number_grandchildren_great_grandchildren", "孙子女/重孙子女数量 (Number of Grandchildren) (范围: ≥0)", value = "", placeholder = "例如：0"),
          selectInput(
            "health_satisfaction",
            "健康满意度 (Health Satisfaction)",
            choices = c(
              "请选择" = "",
              "完全满意" = 1,
              "非常满意" = 2,
              "一般满意" = 3,
              "不太满意" = 4,
              "完全不满意" = 5
            ),
            selected = ""
          ),
          selectInput(
            "life_satisfaction",
            "生活满意度 (Life Satisfaction)",
            choices = c(
              "请选择" = "",
              "完全满意" = 1,
              "非常满意" = 2,
              "一般满意" = 3,
              "不太满意" = 4,
              "完全不满意" = 5
            ),
            selected = ""
          ),
          selectInput(
            "health_compared",
            "与两年前健康状况比较 (Health Compared vs 2 Years Ago)",
            choices = c(
              "请选择" = "",
              "更好了" = 1,
              "差不多" = 2,
              "更差了" = 3
            ),
            selected = ""
          )
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
      plotOutput("importance_plot"),
      
      hr(),
      h4("内在能力分段标准（总分 15 分）"),
      tableOutput("ic_standard_table")
    )
  )
)
