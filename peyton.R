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
cscCA <- city.state.country %>% filter(country=="CA")
write.csv(cscCA, file='./data/CAcity.csv')

##Make German DF
cscDE <- city.state.country %>% filter(country=="DE")
write.csv(cscDE, file='./data/DEcity.csv')


##Combine LatLong Data
USLL <- read_csv('./data/USALatLong.csv')
CALL <- read_csv('./data/CALatLong.csv')
DELL <- read_csv('./data/DELatLong.csv')

ALLLatLong <- rbind(USLL,CALL,DELL)
colnames(ALLLatLong) <- c('city','Country','stateProvince','Latitude','Longitude')

write.csv(ALLLatLong,file='./data/AllLatLong')

##Bind all Lat Long Data to original dataset
datafest2 <- datafest2018
datafestLL <- merge(datafest2,ALLLatLong, by=c('city','stateProvince'))
write.csv(datafestLL,file='datafestll.csv')


datafestLL2 <- datafestLL %>% filter(is.na(Latitude)==FALSE)
write.csv(datafestLL2,file='datafestll2.csv')


##Count of Data per country
countrycount <- datafest2018 %>% group_by(country) %>% summarise(CountryCount=n())

##Salary Exploration
SalaryMeanbyCategory <- datafest2018 %>% 
  group_by(normTitleCategory) %>% 
  summarise(meanSal=mean(estimatedSalary)) %>% 
  arrange(desc(meanSal))

##Company's Average Rating
AverageRatingbyCompany <- datafest2018 %>% group_by(companyId) %>% 
  summarise(meanrating=mean(avgOverallRating),Count=n()) %>% arrange(desc(meanrating),desc(Count))


##Arrange by Salary

datafestSALorder <- datafestLL %>% arrange(desc(estimatedSalary))



