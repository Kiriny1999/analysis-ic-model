# ========================================================
# ShinyApps.io Deployment Helper Script
# ========================================================

# 1. Install rsconnect if not already installed
if (!require("rsconnect")) {
  message("Installing rsconnect package...")
  install.packages("rsconnect")
}
library(rsconnect)

# 2. Authentication
# TODO: REPLACE THE LINES BELOW WITH YOUR CREDENTIALS
# Go to: https://www.shinyapps.io/admin/#/tokens
# Click "Show" -> "Show secret" -> "Copy to clipboard"
# It will look like this:
# rsconnect::setAccountInfo(name='your-account-name',
#                           token='your-token',
#                           secret='your-secret-key')

# Paste your copied command here (uncomment the line below after pasting):
# rsconnect::setAccountInfo(...) 


# 3. Deploy the App
# This uploads the 'shiny_app_ic_model' folder to ShinyApps.io
message("Starting deployment...")
rsconnect::deployApp(
  appDir = "shiny_app_ic_model", 
  appName = "intrinsic-capacity-predictor", # You can change the app name here
  forceUpdate = TRUE
)

