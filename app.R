
library(shiny)
library(tidyverse)
library(readr)
library(leaflet)
library(shinythemes)

meteorite_data <- read_csv("raw_data/meteorite-landings.csv")

# Creating meteor icon for leaflet plot
meteor_icon <- makeIcon(
    iconUrl = "meteor.svg",
    iconWidth = 38, iconHeight = 95,
    iconAnchorX = 0, iconAnchorY = 0
)


# Define UI for application that draws a histogram
ui <- fluidPage(tags$head(tags$style(
    HTML('
             #controls {opacity : 0.7;}
             #date {opacity : 1;}
             #fall {opacity : 1;}')
)),
    navbarPage(theme = shinytheme("united"), 
               collapsible = TRUE,
               "Meteorite Landings", 
               id="nav",
               
            #    tabPanel("Meteorite map",
            #             div(class="outer",
            #               
            # leafletOutput("meteor_plot",
            # width = "100%",
            # height = "auto"),
            # 
            # absolutePanel(id = "controls", 
            #               class = "panel panel-default",
            #              top = 80, 
            #              left = 20, 
            #              width = 250, 
            #              fixed=TRUE,
            #              draggable = TRUE, 
            #              height = "auto",
            #              
            #     sliderInput("date",
            #                 h4("Select a range of years"),
            #                 min = 1399,
            #                 max = 2013,
            #                 value = c(1963, 2013),
            #                 sep = ""),
            #              
            #     checkboxGroupInput("fall", 
            #                     label = h4("Meteors that fell or were found"), 
            #                     choices = list("Fell", 
            #                                    "Found"),
            #                     selected = c("Fell", 
            #                                  "Found"),
            #                     inline = T)
            #     )
            # )
            # )
            # ,
            # 
            tabPanel("Meteorite map",
                         fluidRow(
                           column(2),
                           column(4,
                                  sliderInput("date",
                                              h4("Select a range of years"),
                                              min = 1399,
                                              max = 2013,
                                              value = c(1903, 2013),
                                              sep = "")),
                           column(4,
                                  checkboxGroupInput("fall", 
                                                     label = h4("Meteors that fell or were found"), 
                                                     choices = list("Fell", 
                                                                    "Found"),
                                                     selected = c("Fell", 
                                                                  "Found"),
                                                     inline = T)
                                  ),
                           column(2)),
                     fluidRow(
                       leafletOutput("meteor_plot")
                     ))))

# Define server logic required to draw a histogram
server <- function(input, output) {


    
    
    output$meteor_plot <- renderLeaflet({
      
      meteorite_data %>% 
        filter(
          GeoLocation != "(0.000000, 0.000000)"
          ) %>%
        filter(
          year >= input$date[1]
          ) %>%
        filter(
          year <= input$date[2]
          ) %>% 
        filter(
          fall %in% input$fall
          ) %>% 
        leaflet() %>% 
        addProviderTiles(
          providers$CartoDB.Positron
          ) %>%
        addMarkers(
          lat = ~reclat, 
          lng = ~reclong, 
          clusterOptions = T, 
          icon = meteor_icon, 
          label = ~name
          ) %>% 
        setView(
          lat = 00.00,
          lng = 00.00,
          zoom = 2)
    })
    }

# Run the application 
shinyApp(ui = ui, server = server)
