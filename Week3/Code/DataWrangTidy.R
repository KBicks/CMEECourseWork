################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../Data/PoundHillData.csv",header = F)) 

# header = true because we do have metadata headers
MyMetaData <- read.csv("../Data/PoundHillMetaData.csv",header = T, sep=";", stringsAsFactors = F)

require(dplyr)
require(tidyr)
############# Inspect the dataset ###############
# displays structure of data including dimensions
# same as the str() function
dplyr::glimpse(MyData)
# same as head but includes more info including dimensions
dplyr::tbl_df(MyData) 
dplyr::tbl_df(MyMetaData)
# view data in table
utils::View(MyData)


############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) 
dplyr::tbl_df(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############

# set a data frame, excluding first row of MyData
# creates data frame TempData and removes first row from MyData
TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) 
#stringsAsFactors = F prevents conversion to factors
colnames(TempData) <- MyData[1,] # assign column names from original data

############# Convert from wide to long format  ###############

# reduces data instead of separate counts - long format
MyWrangledData <- TempData %>% gather(., Species, Count, -Cultivation, 
    -Block, -Plot, -Quadrat)
# assign correct data types and set as factors
MyWrangledData <- MyWrangledData %>% mutate(Cultivation = as.factor(Cultivation),
    Block = as.factor(Block), Plot = as.factor(Block), 
    Quadrat = as.factor(Quadrat), Count = as.integer(Count))

dplyr::glimpse(MyWrangledData)
dplyr::tbl_df(MyWrangledData)

############# Start exploring the data (extend the script below)!  ###############
