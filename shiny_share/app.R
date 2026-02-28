library(shiny)

# 定义UI
ui <- fluidPage(
  titlePanel("Shiny计算器"),
  sidebarLayout(
    sidebarPanel(
      h3("操作"),
      numericInput("num1", "第一个数字:", value = 0),
      numericInput("num2", "第二个数字:", value = 0),
      selectInput("operation", "选择操作:", 
                  choices = c("加法" = "+", 
                              "减法" = "-", 
                              "乘法" = "*", 
                              "除法" = "/")),
      actionButton("calculate", "计算")
    ),
    mainPanel(
      h3("结果"),
      verbatimTextOutput("result")
    )
  )
)

# 定义服务器逻辑
server <- function(input, output) {
  # 计算结果
  result <- reactive({
    req(input$calculate)
    
    num1 <- input$num1
    num2 <- input$num2
    op <- input$operation
    
    isolate({
      if (op == "/" && num2 == 0) {
        return("错误: 除数不能为零")
      } else {
        expr <- paste(num1, op, num2)
        return(paste("结果: ", eval(parse(text = expr))))
      }
    })
  })
  
  # 输出结果
  output$result <- renderText({
    result()
  })
}

# 运行应用
shinyApp(ui = ui, server = server)
