#library
library(tidyverse)
library(flexdashboard)
library(magick)
library(janitor)
library(lubridate)
library(patchwork)
library(dplyr)
library(readr)
library(here)



#Adding in the  June 8th collected survey's.


june0608_1 <- read.csv(here("data","N10_202306080727.csv")) %>% 
  clean_names()
  
june0608_2 <- read.csv(here("data","N10_202306081714.csv")) %>% 
  clean_names()

june0608_3 <- read.csv(here("data","N10_202306082043.csv")) %>% 
  clean_names()

june0608_joined <- full_join(june0608_1,june0608_2) %>% 
  full_join(., june0608_3)

#Adding in the  June 9th collected survey's.
june0609_1 <- read.csv(here("data","N10_202306090909.csv")) %>% 
  clean_names()

june0609_2 <- read.csv(here("data","N10_202306091659.csv")) %>% 
  clean_names()

june0609_3 <- read.csv(here("data","N10_202306092013.csv")) %>% 
  clean_names()

june0609_joined <- full_join(june0609_1,june0609_2) %>% 
  full_join(., june0609_3)

#Adding in the  June 10th collected survey's.
june0610_1 <- read.csv(here("data","N10_202306101100.csv")) %>% 
  clean_names()

june0610_2 <- read.csv(here("data","N10_202306101502.csv")) %>% 
  clean_names()

june0610_joined <- full_join(june0610_1,june0610_2)


#Joining all of June 8th-10th Data + exporting the newly joined data frame into a csv file.
three_day_data_survey <- full_join(june0608_joined,june0609_joined) %>% 
  full_join(., june0610_joined) %>% 
  mutate(date = dmy(date)) %>% 
  select(date,species,mantle_length_mm,weight_g) %>% 
  filter(!is.na(mantle_length_mm)) %>% 
  filter(!is.na(weight_g))

write.csv(three_day_data_survey,"C:/Users/Ricardo.Hernandez/Documents/illex_loligo_project/data/3day_loligo_illex_survey.csv")


#Comparing illex versus loligo mantle legnths but it is not working.
str(three_day_data_survey)

ggplot(three_day_data_survey, aes(x=weight_g, y= mantle_length_mm, group = species))+ 
  geom_bar(stat = "Identity")+
  facet_wrap(facets = vars(date))

ggplot(three_day_data_survey, aes(x=weight_g, y= mantle_length_mm))+ 
  geom_area(fill= species)#+
  facet_wrap(facets = vars(date))


# Creating a data frame with just loligo.

loligo <- three_day_data_survey %>% 
  filter( species == "LOLIGO")

loligo_plot <- ggplot(loligo, aes(x=weight_g, y= mantle_length_mm))+ 
  geom_area(fill= "#69b3a2")#+
  #facet_wrap(facets = vars(date))

str(loligo)

#Creating a data frame with just illex
illex <- three_day_data_survey %>% 
  filter( species == "ILLEX")

illex_plot <- ggplot(illex, aes(x=weight_g, y= mantle_length_mm))+ 
  geom_area(fill= "#F16A00")#+
  #facet_wrap(facets = vars(date))


#libraries to load when using ridgeline density chart
library(ggplot2)
library(hrbrthemes)
library(viridis)
library(ggridges)

#attempting to generate ridgeline density charts based on species type

ggplot(three_day_data_survey, aes(x=weight_g, y= mantle_length_mm, group = species))+ 
  geom_density_ridges()+
  facet_wrap(facets = vars(date))+
  theme_ridges()




