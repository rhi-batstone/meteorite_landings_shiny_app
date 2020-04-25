
library(shiny)
library(tidyverse)
library(readr)
library(leaflet)
library(shinythemes)

meteorite_data <- read_csv("raw_data/meteorite-landings.csv")


meteor_icon <- makeIcon(
    iconUrl = "../meteor.svg",
    iconWidth = 38, iconHeight = 95,
    iconAnchorX = 0, iconAnchorY = 0
)


# Define UI for application that draws a histogram
ui <- fluidPage(
    
    theme = shinytheme("united"),

    # Application title
    titlePanel("Meteorite Landings 1399 - 2013"),

    # Sidebar with a slider input for number of bins 
    # sidebarLayout(
    #     sidebarPanel(
    fluidRow(column(6,
            sliderInput("date",
                        h4("Select a range of years"),
                        min = 1399,
                        max = 2013,
                        value = c(1963, 2013),
                        sep = ""),
    ),
    column(6,
            checkboxGroupInput("fall", 
                               label = h4("Meteors that fell or were found"), 
                               choices = list("Fell", 
                                              "Found"),
                               selected = c("Fell", "Found"),
                               inline = T))
            
        ),
    
    fluidRow(

        # Show a plot of the generated distribution
        mainPanel(
            h6("Hover over meteor to view it's name"),
           leafletOutput("meteor_plot",, width = "100%")
        
        )
    )
)

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
