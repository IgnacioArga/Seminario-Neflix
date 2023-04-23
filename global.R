# install.packages("dplyr")
# install.packages("readr")
# install.packages("stringr")
# install.packages("tidyr")
# install.packages("lubridate")
#
# install.packages("ggplot2")
# install.packages("plotly")
# install.packages("ggwordcloud")
#
# install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("DT")

library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(lubridate)

library(ggplot2)
library(plotly)
library(ggwordcloud)

library(shiny)
library(shinydashboard)
library(DT)

data_base <- read.csv("netflix_titles.csv")

data_base <- data_base %>%
  mutate(
    minutes = case_when(
      type == "Movie"~ str_replace(duration, " min", "") %>% as.numeric(),
      TRUE ~ 0
    ),
    seasons = case_when(
      type == "TV Show"~ str_replace(duration, " Season(s)?", "") %>% as.numeric(),
      TRUE ~ 0
    ),
    date_added = mdy(date_added) #convierte a formato fecha
  )

# Generos -----------------------------------------------------------------

# verifico cuantos generos por fila puede haber
data_base %>%
  select(listed_in) %>%
  mutate(
    contador = str_count(listed_in, ",")
  ) %>%
  group_by(contador) %>%
  summarise(cacantidad = n())

# guardo cuales pueden ser los registros únicos
generos_tabla <- data_base %>%
  select(listed_in) %>%
  separate(listed_in, c("gen1","gen2","gen3"), sep = ", ")

generos <- bind_rows(
  generos_tabla %>% select(gen = gen1),
  generos_tabla %>% select(gen = gen2),
  generos_tabla %>% select(gen = gen3)
) %>%
  unique() %>%
  filter(!is.na(gen)) %>%
  pull(gen) %>%
  sort()
