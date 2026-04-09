library(shiny)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  uiOutput("title_ui"),
  uiOutput("lang_button_ui"),
  sidebarLayout(
    sidebarPanel(width = 4, uiOutput("sidebar_ui")),
    mainPanel(width = 8, uiOutput("main_ui"))
  )
)
