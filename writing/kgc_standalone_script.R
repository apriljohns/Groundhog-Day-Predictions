#standalone KGC script to generate CSV for Koppen Zones
#A conflict with dependencies for this package broke summmarize function
#This script will generate a CSV with the Koppen data to be imported into
#the main script for Josh's figure
library(magrittr)
library(readr)
library(kgc)
library(tidyverse)

groundhogs_raw <- read_csv("data/groundhogs_2025.csv")

#requirement to pass a 3 column dataframe with just id, lat, long
#see https://cran.r-project.org/web/packages/kgc/kgc.pdf
data_kgc <- groundhogs_raw %>% 
  select(id, longitude, latitude)

#pass data_kgc into the function
koppen_from_kgc <- data.frame(data_kgc,
                              rndCoord.lon  = RoundCoordinates(data_kgc$longitude),
                              rndCoord.lat = RoundCoordinates(data_kgc$latitude))
koppen_from_kgc <- data.frame(koppen_from_kgc,ClimateZ=LookupCZ(koppen_from_kgc))

#Need a table with the Koppen definitions
unique(koppen_from_kgc$ClimateZ)
us_can_koppen_lookup <- tibble(
  koppen_code = c("BSk", "BWk", "Cfa", "Cfb", "Csb",
                  "Dfa", "Dfb", "Dfc"),
  climate_type = c("Dry Steppe Cold", "Dry Desert Cold", 
                   "Temperate No Dry Season Hot Summer",
                   "Temperate No Dry Season Warm Summer",
                   "Temperate Dry Summer Cold Summer", 
                   "Continental No Dry Season Hot Summer", 
                   "Continental No Dry Season Warm Summer",
                   "Continental No Dry Season Cold Summer"))
#join the tables
koppen_zones <- koppen_from_kgc %>% left_join(us_can_koppen_lookup,
                              by = c("ClimateZ" = "koppen_code"))

#write a CSV and drop in the data folder
write.csv(koppen_zones, file = "data/koppen_zones.csv")

