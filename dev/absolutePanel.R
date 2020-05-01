
## A tab panel with an absolute panel than can be moved across the map
## not as functional as I want so not included in proj

tabPanel(
  "Meteorite map",
  div(
    class = "outer",

    leafletOutput("meteor_plot",
      width = "100%",
      height = "auto"
    ),

    absolutePanel(
      id = "controls",
      class = "panel panel-default",
      top = 80,
      left = 20,
      width = 250,
      fixed = TRUE,
      draggable = TRUE,
      height = "auto",

      sliderInput("date",
        h4("Select a range of years"),
        min = 1399,
        max = 2013,
        value = c(1963, 2013),
        sep = ""
      ),

      checkboxGroupInput("fall",
        label = h4("Meteors that fell or were found"),
        choices = list(
          "Fell",
          "Found"
        ),
        selected = c(
          "Fell",
          "Found"
        ),
        inline = T
      )
    )
  )
)
