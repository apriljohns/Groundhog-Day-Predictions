library(tidyverse)
library(sf)

#cleaning and filtering the shapefile from the International Union for the Conservation of Nature to only include the habitat range of groundhogs (Marmota monax)

mammals <- st_read("MAMMALS_TERRESTRIAL_ONLY.shp") #reading original shapefile

groundhog <- mammals %>% 
  filter(sci_name == "Marmota monax") #filtering to Marmota monax

st_write(groundhog, "groundhog_range.shp") #exporting the new shapefile
