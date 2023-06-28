#libraries to load when using ridgeline density chart
library(ggplot2)
library(hrbrthemes)
library(viridis)
library(ggridges)
library(tidyverse)

# Ricardo - when saving a dataframe to a csv, if you don't want R to add an 
# extra column of row names, include row.names = FALSE, see below
# write.csv(three_day_data_survey , "three_day_data_survey .csv", row.names=FALSE) 

# Read in data
dat <- read.csv('3day_loligo_illex_survey.csv')
# Remove a column of row names
dat<- dat[,-1]

# Here is how to change the class of a column
# Option one : base R
dat[,3] <- as.numeric(dat$mantle_length_mm)
# Option two : dplyr, tidyverse
dat <- dat %>%
  mutate(date = as.Date(date), 
         mantle_length_mm = as.numneric(mantle_length_mm), 
         weight_g = as.numeric(dat$weight_g), 
         as.factor(dat$species))
# Use the date to generate other columns with date info
dat <- dat %>% 
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date)) %>%
  as.data.frame()

# attempting to generate ridgeline density charts based on species type
## Note: all that you needed to change here was that the y value has to be a factor
## so does the fill value (which I changed upstream; line 26). Since you likely 
## don't want mantle_length_mm to always be a factor, you can just specify in 
## line (as below;line 43) rather than converting it in the data frame like 
## we did with species. 

# Here is your original fixed:
ggplot(dat2,
       aes(x=weight_g, y = factor(mantle_length_mm), fill = species)) + 
  geom_density_ridges()+
  facet_wrap(facets = vars(date))+
  theme_ridges()

# You are on the right track! But as you can see, it is a bit hard to interpret 
# the original plot since there are so many mantle lengths 
# The following examples are a bit more straightforward, so go ahead and play 
# around with how you want to display things! 

ggplot(dat2, aes(x = mantle_length_mm, y = species, fill = species)) +
  geom_density_ridges2() + 
  theme_ridges()

ggplot(dat2, aes(x = mantle_length_mm, y = species, fill = species)) +
  geom_density_ridges2() + 
  facet_wrap(~week) + 
  theme_ridges()

ggplot(dat2, aes(x = mantle_length_mm, y = factor(week), fill = factor(week))) +
  geom_density_ridges2() + 
  facet_wrap(~species) + 
  theme_ridges()
