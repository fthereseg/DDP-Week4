require(shiny)
require(data.table)
require(ggplot2)
require(plyr)
require(dplyr)
require(tidyr)
options(warn=-1)

# Defining unnecessary columns
colClasses <- c("Area Code" = "NULL", "Item Code" = "NULL", "Element Code" = "NULL",
                "Year Code" = "NULL", "Flag" = "NULL")

#Downloading database
temp <- tempfile()
download.file("http://fenixservices.fao.org/faostat/static/bulkdownloads/Forestry_E_All_Data_(Normalized).zip",temp)

forestry <- fread(unzip(temp, files = "Forestry_E_All_Data_(Normalized).csv"), header = TRUE, nrows = 1900000, 
                  colClasses = colClasses, showProgress = TRUE,
                  fill = TRUE)
rm(temp)

#Tidying the data 
forestry <- as.data.frame(forestry)
forestry$Area <- as.factor(forestry$Area)
forestry$Item <- as.factor(forestry$Item)
forestry$Element <- as.factor(forestry$Element)
forestry$Year <- as.numeric(forestry$Year)
forestry$Unit <- as.factor(forestry$Unit)
forestry$Value <- as.numeric(forestry$Value)

#transpositioning - 1 
forestry <- spread(forestry, key = Element, value = Value, fill = 0)

colnames(forestry)[5] <- "Export.Quantity"
colnames(forestry)[6] <- "Export.Value"
colnames(forestry)[7] <- "Import.Quantity"
colnames(forestry)[8] <- "Import.Value"

forestry <- mutate(forestry, Quantities.Sum = Export.Quantity + Import.Quantity + Production)

#transpositioning - 2
forestry <- spread(forestry, key = Unit, value = Quantities.Sum, fill = 0)
forestry$`1000 US$` <- NULL
forestry <- aggregate(. ~ Area + Item + Year, data = forestry, FUN = sum)

#Creating Unit column
forestry <- mutate(forestry, Unit = ifelse(forestry$m3 != 0, "m3", "ton"))
forestry$m3 <- NULL
forestry$tonnes <- NULL

#Creating Export.Price variable
forestry <- mutate(forestry, Export.Price = Export.Value * 1000 / Export.Quantity)
#Creating Import.Price variable
forestry <- mutate(forestry, Import.Price = Import.Value * 1000 / Import.Quantity)
#Creating Int.Consuption variable
forestry <- mutate(forestry, Int.Consumption = Production + Import.Quantity - Export.Quantity)

#Subsetting for export_prices_Plot
forestry_exp_prices <- subset(forestry, !is.nan(Export.Price))

#Subsetting for int_consumption_Plot
forestry_int_consumption <- subset(forestry, !is.nan(Int.Consumption))

#Subsetting for import_prices_Plot
forestry_imp_prices <- subset(forestry, !is.nan(Import.Price))