#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
function(input, output, session) {

  # Filtro la data ----------------------------------------------------------

  data_filtrada <- reactive({

    data <- data_base %>%
      filter(
        release_year >= input$date[1], release_year <= input$date[2],
        date_added >= input$date_netflix[1], date_added <= input$date_netflix[2],
        type == input$type
      )

    data <- if (input$gender != "") {
      data[grepl(input$gender, data$listed_in),]
    } else{
      data
    }

    data <- if (input$type == "Movie") {
      data  %>%
        filter(
          minutes >= input$duration[1], minutes <= input$duration[2]
        )
    } else {
      data  %>%
        filter(
          seasons >= input$duration[1], seasons <= input$duration[2]
        )
    }
  })

  # Gráfico de barras -------------------------------------------------------

  output$plot_duration <- renderPlotly({

    if (input$type == "Movie") {
      data <- data_filtrada() %>%
        filter(!is.na(minutes))

      plot_ly(
        data = data,
        x    = ~ minutes,
        type = "histogram"
      )
    } else {
      data <- data_filtrada() %>%
        filter(!is.na(seasons)) %>%
        mutate(seasons = as.factor(seasons)) %>%
        group_by(seasons) %>%
        summarize(
          count = n()
        )

      plot_ly(
        data = data,
        x    = ~seasons,
        y    = ~count,
        type = "bar"
      )
    }
  })


  # Nube de palabras --------------------------------------------------------

  output$plot_words <- renderPlot({

    grafico1 <- data_filtrada() %>%
      group_by(country) %>%
      summarise(cantidad = n()) %>%
      arrange(desc(cantidad)) %>%
      head(10)

    ggplot(
      data = grafico1,
      mapping = aes(
        label = country,
        size = cantidad,
        color = factor(sample.int(10, nrow(grafico1), replace = TRUE)),
        angle = 90 * sample(c(0, 1), nrow(grafico1), replace = TRUE, prob = c(80, 20))
      )
    ) +
      geom_text_wordcloud() +
      scale_size_area(max_size = 40) +
      theme_minimal()
  })


  # Tabla -------------------------------------------------------------------

  output$tabla <- renderDT({
    datatable(
      data_filtrada(),
      rownames = FALSE,
      filter   = 'top'
    )
  })

  observeEvent(input$type, {
    if (input$type == "Movie") {
      updateSliderInput(
        inputId = "duration",
        label   = "Minutos:",
        value   = c(0,300),
        min     = 0,
        max     = 300
      )
    } else {
      updateSliderInput(
        inputId = "duration",
        label   = "Temporadas:",
        value   = c(1,16),
        min     = 1,
        max     = 16
      )
    }
  })
}

