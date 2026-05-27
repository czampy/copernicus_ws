# load necessary packages -------------------------------------------------

# for data.frames handling
library(tidyr)
library(dplyr)
# for spatial data handling
library(terra)
library(sf)

# load and explore CMEMS data ---------------------------------------------

# use the function list.files() to list the files in our folder examples_data
cmems_files <- list.files("../examples_data/",full.names = T,pattern = "cmems")
cmems_files

# use the function rast() to load the files in RStudio
cmems_data <- rast(cmems_files)
cmems_data

# check raster object features
varnames(cmems_data)
time(cmems_data)
names(cmems_data)

# change layers names
names(cmems_data) <- paste(gsub("_.*","",names(cmems_data)),time(cmems_data),sep = '_')
names(cmems_data)

# visualise raster object
plot(cmems_data,main=names(cmems_data))

# extract data by location and time ---------------------------------------

# load data with occurrence locations
# file.choose() in row 11 opens a window to explore your local files and find your data and select the one you need
# alternatively you can write the path to your file between "" instead of file.choose()
# if your data are not in a csv, use the "Import Dataset" button in the "Environment" panel on your right
sample_xy <- read.csv(file.choose(),dec = ".",sep = ";")
head(sample_xy)

# visualise points over raster
plot(cmems_data,1,main=names(cmems_data)[1])
points(sample_xy$Lon,sample_xy$Lat,pch=16,add=TRUE)

# extract values at locations
cmems_extr <- extract(cmems_data,sample_xy[,c(3,2)]) %>%
  pivot_longer(cols = -1,names_to = "layer",values_to = "value") %>%
  separate(layer,into = c("var","Date"),sep = "_") %>%
  pivot_wider(id_cols = c(ID,Date),names_from = var,values_from = value)
cmems_extr

# modify samples table to match ID and dates of the extraction table
sample_xy2 <- sample_xy %>%
  separate(Date,into = c("day","month","year"),sep = "/") %>% select(-day) %>%
  mutate(ID = 1:nrow(sample_xy),Date = paste(year,month,"01",sep = "-"),.keep = "unused") %>%
  left_join(cmems_extr,by = c("ID","Date"))
sample_xy2

# save data ---------------------------------------------------------------
# save your updated dataset in an R friendly format
save(catch_env,file = "your/path/sample_env.RData")
# or as a csv file
write.csv(sample_xy2,file = "your/path/sample_env.csv",row.names = FALSE)
