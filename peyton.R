##DATAFEST
##April 6-8, 2018
##Peyton Wood, Jason Thompson, Graham Pash, Vinett, Sam


##Set WD
setwd("C:/Users/peyto/OneDrive/Documents/Datafest/df2018")
Packages <- c("dplyr", "ggplot2", "readr","magrittr","ggmap")
lapply(Packages, library, character.only = TRUE)

##Read in data
data <- "./data/datafest2018.csv"
datafest2018 <- read_csv(data)

numjobID<- datafest2018 %>% group_by(jobId) %>% summarize(n())


#subset to work on in Tableu
subsetdf18<- datafest2018[1:10000,]
write.csv(subsetdf18,file='subsetdf18.csv')


##Generate Lat Logn Data
allcity_counts <- datafest2018 %>% 
  group_by(city) %>% select(city,stateProvince,country) 

##Make DF with all city state country
city.state.country <- allcity_counts %>% group_by(city,stateProvince,country) %>% summarise(ncity=n())

##Make US DF
cscUSA <- city.state.country %>% filter(country=="US")
write.csv(cscUSA, file='./data/USAcity.csv')

##Make Canada DF
cscUSA <- city.state.country %>% filter(country=="US")

##Make German DF
cscUSA <- city.state.country %>% filter(country=="US")


citynames <- datafest2018[,4:6]                         

write.csv(city.state.country, file='./data/citynames3.csv')



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