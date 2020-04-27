library(shiny)
library(shinythemes)
library(ggplot2)
library(tidyverse)
library(zoo)
library(lubridate)
library(scales)
library(plotly)
library(DT)


data = read.csv('crypto_data_v2.csv')

# format date column to dates

data$trade_date = mdy(data$trade_date)

# create dataframe to be used for overview tab

group_data = data %>%  group_by(group,trade_date) %>% 
  summarise(market_cap = sum(market_cap)) %>% 
  mutate(day_before = lag(market_cap,1)) %>% 
  mutate(percent_change = (market_cap-day_before)/day_before) %>% 
  mutate(vol_group = rollapply(percent_change,30,sd,partial=TRUE)) %>% 
  drop_na() %>%
  group_by(trade_date,group) %>%
  mutate(market_cap = sum(market_cap)/1000000000)