# Load the required libraries
library(UsingR)
library(plyr)
library(dplyr)
library(shiny)
library(ggplot2)
library(RColorBrewer)
library(rMaps)
library(choroplethr)
library(choroplethrMaps)
library(data.table)
require(rCharts)
# Data Citation:
# The data for this project was obtained from the Centers for Disease Control and Prevention, 
#   National Center for Health Statistics. Underlying Cause of Death 1999-2014 on CDC WONDER 
#   Online Database, released 2015. Data are from the Multiple Cause of Death Files, 1999-2014,
#   as compiled from data provided by the 57 vital statistics jurisdictions through the 
#   Vital Statistics Cooperative Program. 
# This data was accessed at 
#   http://wonder.cdc.gov/ucd-icd10.html 
#   on Feb 29, 2016 2:19:06 PM
# 
# Read in the original dataset
dataset1 <- read.csv("./dataset1.csv",stringsAsFactors = FALSE)

# Get state abbreviation from the state.abb file
dataset2 <- mutate(dataset1, state = state.abb[match(State,state.name)])

# Keep only the stats for Drug and Alcohol Induced Deaths
dataset2 <- subset(dataset2,Drug.Alcohol.Induced.Causes != "All Other Causes")

# Convert the death rate to numeric
dataset2$Crude.Rate <- as.numeric(dataset2$Crude.Rate)

# Convert missing values to 0
dataset2$Crude.Rate[is.na(dataset2$Crude.Rate)] <- 0

# Select only the columns needed
dataset2 <- select(dataset2,c(1,3,5,7,11,12))

# Rename the full state name to "state_name", and rename the abb to "State"
names(dataset2)[names(dataset2)=="State"] <- "state_name"
names(dataset2)[names(dataset2)=="state"] <- "State"

shinyServer(function(input, output) {
    
   output$chart1 <- renderChart2({

# Calculate the sum of Drug and Alcohol Induced deaths, if the user chooses "Both"   

     if(input$cause == "Both Drug and Alcohol Induced Causes")  {
          temp <- subset(dataset2,Year==input$year & Race==input$race)
          by_stateraceandyear <- group_by(temp,State,Race,Year)
          dataset3 <- summarise(by_stateraceandyear, Crude.Rate = sum(Crude.Rate))
      
        }

# No calculation needed if user chooses Drug-Induced or Alcohol-Induced deaths 
     
     else {dataset3 <- subset(dataset2,Year==input$year & Race==input$race & 
                            Drug.Alcohol.Induced.Causes==input$cause)
     }
     
# Create map using ichoropleth function      

   ichoropleth(Crude.Rate~State, dataset3, map="usa",
                        pal='Blues',labels=FALSE,legend=TRUE,ncuts=7)
   })
   
   output$mytable <- renderDataTable({data.table(dataset2,keep.rownames=FALSE,
                                                check.names=FALSE, key=NULL)})
 
   


   
})
    
