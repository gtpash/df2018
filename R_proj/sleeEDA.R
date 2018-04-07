library(dplyr)
library(ggplot2)
library(readr)
#library(ggmap)

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
unique(datafest$salaryCurrency)

#replace NAs of salary Currency with proper currency based on salary data.
indexNASalary<-which(is.na(datafest$salaryCurrency))
indexNASalary

for(i in datafest$country[indexNASalary]){
  j=1
  if(i=="US"){
    datafest$salaryCurrency[indexNASalary[j]]="USD"
  }
  else if(i=="DE"){
    datafest$salaryCurrency[indexNASalary[j]]="EUR"
    
  }
  else if(i=="CA"){
    datafest$salaryCurrency[indexNASalary[j]]="CAD"
  }
  j=j+1
}
  
