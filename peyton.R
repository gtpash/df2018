##DATAFEST
##April 6-8, 2018
##Peyton Wood, Jason Thompson, Graham Pash, Vinett, Sam


##Set WD
setwd("C:/Users/peyto/OneDrive/Documents/Datafest/df2018-master")
Packages <- c("dplyr", "ggplot2", "readr","magrittr","ggmap")
lapply(Packages, library, character.only = TRUE)

##Read in data
data <- "./data/datafest2018.csv"
datafest2018 <- read_csv(data)

numjobID<- datafest2018 %>% group_by(jobId) %>% summarize(n())





#Vinit's Code
datafest2018 %>% group_by(companyId) %>% summarize(n()) -> companies
datafest2018 %>% filter(companyId == "company00090") %>% mean(.$estimatedSalary)
city_counts <- datafest2018 %>% group_by(city) %>% summarize(n()) %>% arrange(desc(`n()`)) %>% slice(2:12501)
#write_csv(city_counts,"./data/city_counts.csv")
industries <- datafest2018 %>% group_by(industry) %>% summarize(n()) %>% arrange(desc(`n()`))
#n <- 1
#locs <- city_counts$city[n:(n+2)]
#
#geoLocations <- geocode(as.character(locs))