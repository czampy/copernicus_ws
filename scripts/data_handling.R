# load necessary packages -------------------------------------------------

# for data.frames handling
library(tidyr)
library(dplyr)
# for spatial data handling
library(terra)
library(sf)

# load data with occurrence locations
# file.choose() in row 11 opens a window to explore your local files and find your data and select the one you need
# alternatively you can write the path to your file between "" instead of file.choose()
# if your data are not in a csv, use the "Import Dataset" button in the "Environment" panel on your right
sample_xy <- read.csv(file.choose(),dec = ".",sep = ";")

sample_xy$ID_env <- 1:nrow(sample_xy) # make a column with an ID per each entry of your data
# convert your "Date" column in a different format with day equal to 1 (the env data are monthly)
sample_xy <- sample_xy %>%
  separate(Date,into = c("day","month","year"),sep = "/") %>%
  mutate(Date = as.Date(paste(year,month,"01",sep = "-")),.keep = "unused")

# covariates extraction ---------------------------------------------------

## physical and biological covariates -------------------------------------

# here we're going to upload all the nc files you downloaded from Copernicus
# you should substitute the "data/env" part with the path to the folder where you saved the files
rean.files <- list.files("C:/Users/Carlo/OneDrive - Università degli Studi di Padova/Documents/copernicus_ws",full.names = T,pattern = "cmems")
rean.data <- rast(rean.files)
rean.data
varnames(rean.data)
time(rean.data)
names(rean.data) <- paste(gsub("_.*","",names(rean.data)),time(rean.data),sep = '_')

# in the next line, substitute 13 and 12 with the indices of the columns where your coordinates are saved (first longitude then latitude)
catch_rean <- extract(rean.data,sample_xy[,c(3,2)]) %>%
  pivot_longer(cols = -1,names_to = "layer",values_to = "value") %>%
  separate(layer,into = c("var","Date"),sep = "_") %>%
  pivot_wider(id_cols = c(ID,Date),names_from = var,values_from = value) %>%
  mutate(Date =as.Date(Date))

# merge your locations data with the extracted environmental data
catch_rean2 <- sample_xy %>% left_join(catch_rean,by = c("ID_env"="ID","Date"))
head(catch_env)
summary(catch_env)

# save data ---------------------------------------------------------------
# save your updated dataset in an R friendly format
save(catch_env,file = "your/path/sample_env.RData")
