# load packages ------------

# Remember to install the packages first!
# Select the lines and hit run OR press CTRL+ENTER

library(tidyverse)
library(here)
library(skimr)

# read in data -------------

# = can be used instead of "<-"
beaches <- read_csv(here("data", "sydneybeaches.csv"))


# explore data --------------

## view the data like a worksheet -----
View(beaches)

## dimensions -----
dim(beaches)

## structure ------
str(beaches)

## cleaner structure in table -----
glimpse(beaches)

## see first few rows -----
head(beaches)

## see last few rows -----
tail(beaches)

## summary of the data -----
summary(beaches)

# skimr -------
# install first! install.packages("skimr")

skim(beaches)

