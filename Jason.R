JasonWorkingDirectory <- "C:/Users/jason/Documents/Datafest/df2018"
setwd(JasonWorkingDirectory)
Packages <- c("dplyr", "ggplot2", "readr","magrittr","ggmap")
lapply(Packages, library, character.only = TRUE)

#timing code
time1 <- proc.time()
print(paste0(round(((proc.time() - time1)[3])/60,digits = 3)," minutes from start"))

data <- "./data/datafest2018.csv"
datafest2018 <- read_csv(data)

datafest2018 %>% group_by(companyId) %>% summarize(n()) -> companies
mean((datafest2018 %>% filter(companyId == "company00090"))$estimatedSalary)
city_counts <- datafest2018 %>% group_by(city) %>% summarize(n()) %>% arrange(desc(`n()`))
#write_csv(city_counts,"./data/city_counts.csv")
industries <- datafest2018 %>% group_by(industry) %>% summarize(n()) %>% arrange(desc(`n()`))
total_city_counts <- datafest2018 %>% group_by(city) %>% summarize(n()) %>% arrange(desc(`n()`))
city_counts_noones <- total_city_counts %>% filter(`n()`!=1)

#city_counts <- city_counts %>% filter(`n()`<300000)
city_counts_500 <- total_city_counts %>% filter(`n()`<=500)
city_counts_1000 <- total_city_counts %>% filter(`n()`>500 &`n()`<=1000)
city_counts_2000 <- total_city_counts %>% filter(`n()`>1000 &`n()`<=2000)
city_counts_5000 <- total_city_counts %>% filter(`n()`>2000 &`n()`<=5000)

counts_list <- list(city_counts_500,city_counts_1000,city_counts_2000,city_counts_5000)

for(i in 1:length(counts_list)){
  hist(counts_list[[i]]$`n()`)
}


# looking at currencies
datasamp <- sample_n(datafest2018,100000)
datafest2018$salaryCurrency <- ifelse(!is.na(datafest2018$salaryCurrency),
                                      datafest2018$salaryCurrency,
                                  ifelse(datafest2018$country=="US","USD",
                                         ifelse(datafest2018$country=="DE","EUR",
                                                ifelse(datafest2018$country=="CA","CAD","miss"))))





justsalaries <- datafest2018 %>% select(c(estimatedSalary,salaryCurrency,country))
salarysamp <- sample_n(justsalaries,100000)
sal_summ <- ddply(salarysamp,c(""))









#n <- 1
#locs <- city_counts$city[n:(n+2)]
#
#geoLocations <- geocode(as.character(locs))