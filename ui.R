#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
fluidPage(

  # Application title
  titlePanel(
    title = tagList(
      "Buscador de ",
      tags$img(
        src = "Netflix_Logo.png",
        height = "40px",
        style = "margin-top: -7px;"
      )
    )
  ),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "date",
        "Fecha de estreno:",
        min = 1925,
        max = 2021,
        value = c(1925,2021)
      ),
      dateRangeInput(
        "date_netflix",
        "Fecha de lanzamiento en Neflix:",
        start = "2008-01-01",
        end   = "2021-09-25",
        min   = "2008-01-01",
        max   = "2021-09-25"
      ),
      selectInput(
        "type",
        "Tipo:",
        choices  = c("Movie", "TV Show"),
        selected = "Movie"
      ),
      selectizeInput(
        "gender",
        "Genero",
        choices = generos,
        selected = NULL,
        options = list(
          placeholder = "Seleccionar genero...",
          onInitialize = I('function() { this.setValue(""); }')
        )
      ),
      sliderInput(
        "duration",
        "Minutos:",
        min   = 0,
        max   = 300,
        value = c(0,300)
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabBox(
        width = 12,
        tabPanel(
          title = "Resumen",
          plotlyOutput("plot_duration"),
          plotOutput("plot_words",width = "100%")
        ),
        tabPanel(
          title = "Detalle",
          DTOutput("tabla")
        )
      )

    )
  )
)
