vinitWorkingDirectory <- "~/Documents/df2018"
setwd(vinitWorkingDirectory)
Packages <- c("dplyr", "ggplot2", "readr","magrittr","ggmap")
lapply(Packages, library, character.only = TRUE)

data <- "./data/datafest2018.csv"
datafest2018 <- read_csv(data)

datafest2018 %>% group_by(companyId) %>% summarize(n()) -> companies
mean((datafest2018 %>% filter(companyId == "company00090"))$estimatedSalary)
city_counts <- datafest2018 %>% group_by(city) %>% summarize(n()) %>% arrange(desc(`n()`)) %>% slice(2:12501)
#write_csv(city_counts,"./data/city_counts.csv")
industries <- datafest2018 %>% group_by(industry) %>% summarize(n()) %>% arrange(desc(`n()`))
#n <- 1
#locs <- city_counts$city[n:(n+2)]
#
#geoLocations <- geocode(as.character(locs))
all_cities <- datafest2018 %>% group_by(city) %>% select(city, stateProvince, country) %>% summarize(n())
sector_dict <- read_csv("./data/sectors.csv")
datafest2018 <- merge(datafest2018,sector_dict,by.x = "normTitleCategory",by.y = "industry_name", all.x = TRUE)
