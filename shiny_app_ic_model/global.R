library(shiny)
library(xgboost)
library(ggplot2)
library(bslib)
library(shapviz)
library(showtext)

# Enable showtext for Chinese character support in plots
showtext_auto()
# Use a font that supports Chinese (e.g., "wqy-microhei" is common on Linux/ShinyApps.io)
# For local Mac/Windows, we might need a fallback or just use showtext's ability to load system fonts
# Here we try to add a standard font. 
# "WenQuanYi Micro Hei" is often available on Linux servers.
# For broad compatibility, we can add a Google font or use system default if available.
font_add_google("Noto Sans SC", "noto_sans")


# Load the model globally
model_path <- "model/xgb_booster.rds"
if (file.exists(model_path)) {
  xgb_model <- readRDS(model_path)
} else {
  stop("Model file not found at ", model_path)
}

# Define feature names in the EXACT order as the model expects
feature_names <- c(
  "age",                                      
  "hematocrit",                               
  "number_pain_locations",                    
  "number_grandchildren_great_grandchildren", 
  "waist_circumference",                      
  "education_level",                          
  "triglycerides",                            
  "uric_acid",                                
  "year_smoke",                               
  "health_satisfaction",                      
  "number_chronic_disease",                   
  "year_diseases_arthritis",                  
  "health_compared",                          
  "number_social_activities",                 
  "life_satisfaction",                        
  "number_smoke",                             
  "treat_pain_无疼痛",                        
  "treat_pain_有疼痛且治疗",                  
  "treat_pain_有疼痛不治疗",                  
  "address_urban_or_rural_主城区",            
  "address_urban_or_rural_城乡结合部",        
  "address_urban_or_rural_镇中心",            
  "address_urban_or_rural_镇乡",              
  "address_urban_or_rural_特殊区域",          
  "address_urban_or_rural_乡中心",            
  "address_urban_or_rural_村庄",              
  "literate_不识字",                          
  "literate_识字",                            
  "martial_status_已婚与配偶一同居住",        
  "martial_status_已婚但配偶暂时不在一起居住",
  "martial_status_已婚但配偶在外地工作",      
  "martial_status_离异",                      
  "martial_status_丧偶",                      
  "martial_status_从未结婚",                  
  "martial_status_同居"                      
)

# Define Chinese labels for features
feature_labels <- c(
  "age" = "年龄",
  "hematocrit" = "血红蛋白",
  "number_pain_locations" = "疼痛部位数量",
  "number_grandchildren_great_grandchildren" = "孙子女/重孙子女数量",
  "waist_circumference" = "腰围",
  "education_level" = "教育水平",
  "triglycerides" = "甘油三酯",
  "uric_acid" = "尿酸",
  "year_smoke" = "吸烟年数",
  "health_satisfaction" = "健康满意度",
  "number_chronic_disease" = "慢性病数量",
  "year_diseases_arthritis" = "关节炎患病年数",
  "health_compared" = "与两年前健康状况比较",
  "number_social_activities" = "社会活动数量",
  "life_satisfaction" = "生活满意度",
  "number_smoke" = "吸烟数量",
  "treat_pain_无疼痛" = "疼痛治疗:无疼痛",
  "treat_pain_有疼痛且治疗" = "疼痛治疗:有疼痛且治疗",
  "treat_pain_有疼痛不治疗" = "疼痛治疗:有疼痛不治疗",
  "address_urban_or_rural_主城区" = "居住地:主城区",
  "address_urban_or_rural_城乡结合部" = "居住地:城乡结合部",
  "address_urban_or_rural_镇中心" = "居住地:镇中心",
  "address_urban_or_rural_镇乡" = "居住地:镇乡",
  "address_urban_or_rural_特殊区域" = "居住地:特殊区域",
  "address_urban_or_rural_乡中心" = "居住地:乡中心",
  "address_urban_or_rural_村庄" = "居住地:村庄",
  "literate_不识字" = "识字:不识字",
  "literate_识字" = "识字:识字",
  "martial_status_已婚与配偶一同居住" = "婚姻:已婚同居",
  "martial_status_已婚但配偶暂时不在一起居住" = "婚姻:已婚分居",
  "martial_status_已婚但配偶在外地工作" = "婚姻:配偶外地",
  "martial_status_离异" = "婚姻:离异",
  "martial_status_丧偶" = "婚姻:丧偶",
  "martial_status_从未结婚" = "婚姻:未婚",
  "martial_status_同居" = "婚姻:同居"
)
