# Load the necessary libraries
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

options(RCHART_LIB='Datamaps')

# Retrieve user input and render the output passed from server.r

shinyUI(fluidPage(
  #pageWithSidebar(
  titlePanel("Drug and Alcohol Deaths per 100,000 population"),
   
# Retrieve the user input

  sidebarPanel( 
    selectInput(inputId="year",
                label = "Select year:",
                choices= c(2012,2013,2014),
                selected="2012"),
    selectInput(inputId="race",
                label = "Select race:",
                choices= c("American Indian or Alaska Native","Asian or Pacific Islander",
                        "Black or African American","White"),
                selected="White"),
    selectInput(inputId="cause",
                label = "Select cause of death:",
                choices = c("Drug-Induced Causes","Alcohol-Induced Causes","Both Drug and Alcohol Induced Causes"),
                selected="Drug-Induced Causes")),
    
# Render the output created by server.r


  mainPanel(
    tabsetPanel(
      
          tabPanel("About this App",

          helpText(br("This app displays the death rates across the 50 United States, from drug
                   and alcohol induced causes.  The user can select from a dropdown any of
                   4 racial groups (White, Black or African American, American Indian or Alaska
                   Native, Asian or Pacific islander), as well as a year (from 2012 to 2014) 
                   and a cause of death (Drug-Induced, Alcohol-Induced, or Both. When the user 
                   chooses 'Both', a calculation is performed to add the two causes of death 
                   together."),
                   br("Death rates are shown as a number of deaths per 100,000 population. The data
                   are depicted in 7 quantiles, each with an equal number of states in it. Any
                   state that appears black on the map indicates that there was insufficient data
                   available for the particular state, year, race, and cause selected."),
                   br("A choropleth map is depicted on the tab marked",strong(" Plot "),
                   "and the underlying data table is available on the tab marked", strong(" Table "),
                   "The data table is searchable"))),
                   
          
          tabPanel(
            "Plot", 
            showOutput("chart1","datamaps")),     
          
          tabPanel(
            "Data Table", 
            dataTableOutput("mytable"))
               )
           )
  
))
