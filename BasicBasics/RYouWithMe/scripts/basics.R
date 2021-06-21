# load packages ------------
asdasdf +1
# adasdfsdf + 1
# Remember to install the packages first!
# Select the lines and hit run OR press CTRL+ENTER

library(tidyverse)
library(here)
library(skimr)


# read in data -------------

# = can be used instead of "<-"
# remember many function names are close or overlap!!!
# readr::read_csv
beaches <- read_csv(here("data", "sydneybeaches.csv"))

# same thing with code below

beaches <- readr::read_csv(here::here("data", "sydneybeaches.csv"))

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

