#setwd("C:/Users/graha/Dropbox/Graham/documents/GitHub/df2018")
# mykey <- "AIzaSyBz0PcAiiaSE_PGKXivzUGOk8vw4fs40Ek" #graham

packs <- c("dplyr","ggplot2","readr","magrittr","ggmap")
lapply(packs,library,character.only = TRUE)

raw <- readr::read_csv("./datafest2018.csv")

company <- summarise(group_by(raw,companyId), count = n())

# save city locations in csv
city_counts <- raw %>% group_by(city) %>% summarize(n()) %>% arrange(desc(`n()`)) %>% slice(2:12501)

n <- 1
locs <- city_counts$city[n:(n+20)]

ggmap::register_google(key = mykey)

locs <- cbind(ggmap::geocode(as.character(locs)),locs)
raw <- cbind(raw,geoLocations)

