library(dplyr)
library(ggplot2)
library(readr)
library(ggmap)

datafest<-read_csv("GitHub/df2018/data/datafest2018.csv")

n_distinct(datafest$jobId) #1082908
n_distinct(datafest$companyId) #252432
n_distinct(datafest$country) #3
n_distinct(datafest$industry) #206
n_distinct(datafest$normTitleCategory) #58
n_distinct(datafest$stateProvince) #87
n_distinct(datafest$city) #22217
n_distinct(datafest$jobLanguage) #3
n_distinct(datafest$date) #395

company<-summarise(group_by(datafest, companyId), count=n())
#quick boxplots
boxplot(company$count)
boxplot(datafest$estimatedSalary)
boxplot(datafest$jobAgeDays)

max(company$count) #321687
filter(company, company$count>20000)

USJobs<-filter(datafest, datafest$country=="US")
uniqueCity<-unique(datafest$city)


locations <- paste(USJobs[1:1000,]$city, USJobs[1:1000,]$stateProvince)
geoLocations <- geocode(as.character(uniqueCity[1:1000]))

