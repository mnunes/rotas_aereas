library(tidyverse)
theme_set(theme_bw())
library(brazilmaps)
library(janitor)

# leitura dos dados

aeroportos_br <- clean_names(read.csv(file = "dados/aeroportos_br.csv"))
aeroportos    <- clean_names(read.csv(file = "dados/Full_Merge_of_All_Unique Airports.csv"))
rotas         <- clean_names(read.csv(file = "dados/Full_Merge_of_All_Unique_Routes.csv"))

# manter apenas as rotas dentro do brasil

rotas_br <-
  rotas %>%
  filter(departure %in% aeroportos_br$id) %>%
  filter(destination %in% aeroportos_br$id)
  
# juntar rotas e localizacao dos aeroportos

rotas_br <- 
  rotas_br %>%
  rename(id = departure) %>%
  left_join(aeroportos, by = "id") %>%
  select(departure = id, destination, latitude_dep = latitude, longitude_dep = longitude) %>%
  rename(id = destination) %>%
  left_join(aeroportos, by = "id") %>%
  select(departure, destination = id, latitude_dep, longitude_dep, latitude_des = latitude, longitude_des = longitude)

# numero de voos por rota

rotas_br <- 
  rotas_br %>%
  group_by(departure, destination) %>%
  count() %>%
  left_join(rotas_br, by = c("departure", "destination")) %>%
  arrange(n)

# mapa

mapa_br <- get_brmap("State")

ggplot(mapa_br) +
  geom_sf(fill = "white") +
  geom_segment(data = rotas_br, aes(x = longitude_dep, y = latitude_dep, xend = longitude_des, yend = latitude_des, colour = as.factor(n))) +
  labs(x = "Latitude", y = "Longitude", colour = "Qtde", caption = "marcusnunes.me") +
  scale_color_viridis_d() + 
  theme_void()

# rotas mais comuns

rotas_br %>% 
  arrange(desc(n)) %>% 
  unique() %>% 
  select(departure, destination, n) %>%
  filter(n >= 5) %>%
  kable()


