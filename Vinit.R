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

#run CleanR.R

mean(clean$days_active)
sd(clean$days_active)
sectors <- unique(sector_dict$sector)
for (i in sectors){
  print(i)
  print(mean((clean %>% filter(sector == i))$days_active))
  print(sd((clean %>% filter(sector == i))$days_active))
}

mean(clean$sum_clicks)
sd(clean$sum_clicks)
for (i in sectors){
  print(i)
  print(mean((clean %>% filter(sector == i))$sum_clicks))
  print(sd((clean %>% filter(sector == i))$sum_clicks))
}

mean(clean$sum_localclicks)
sd(clean$sum_localclicks)
for (i in sectors){
  print(i)
  print(mean((clean %>% filter(sector == i))$sum_localclicks))
  print(sd((clean %>% filter(sector == i))$sum_localclicks))
}

mean((clean %>% filter(avgOverallRating > 0))$avgOverallRating)
sd((clean %>% filter(avgOverallRating > 0))$avgOverallRating)
for (i in sectors){
  print(i)
  print(mean((clea %>% filter(sector == i, avgOverallRating>0))$avgOverallRating))
  print(sd((clean %>%filter(sector == i, avgOverallRating>0))$avgOverallRating))
}