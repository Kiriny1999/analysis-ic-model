library(shiny)
library(xgboost)
library(ggplot2)
library(bslib)

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
