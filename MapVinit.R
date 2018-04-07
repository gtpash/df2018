thisWorkingDirectory <- "~/Documents/df2018Data"
setwd(thisWorkingDirectory)
Packages <- c("dplyr", "ggplot2", "readr","magrittr","ggmap", "sp")
lapply(Packages, library, character.only = TRUE)
readRDS("CAN_adm0.rds")
