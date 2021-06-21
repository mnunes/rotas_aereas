library(rvest)
library(tidyverse)
library(janitor)

url <- "https://pt.wikipedia.org/wiki/Lista_de_aeroportos_do_Brasil_por_c%C3%B3digo_aeroportu%C3%A1rio_IATA"

tabelas <- url %>%
  read_html() %>%
  html_table(fill=TRUE)

aeroportos <- tabelas[[1]]

for (j in 2:5){
  aeroportos <-
    aeroportos %>%
    bind_rows(tabelas[[j]])
}

aeroportos <- clean_names(aeroportos)

aeroportos <- 
  aeroportos %>%
  rename(id = codigo_iata)

write.csv(aeroportos, 
          file = "dados/aeroportos_br.csv", 
          quote = FALSE, 
          row.names = FALSE)




