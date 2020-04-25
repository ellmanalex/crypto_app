library(shiny)
library(shinythemes)
library(ggplot2)
library(dplr)
library(zoo)
library(lubridate)
llibrary(scales)


data = read.csv('crypto_data.csv')

# format date column to dates

data$trade_date = as.Date(data$trade_date)

# create dataframe to be used for overview tab

group_data = data %>% summarise(market_cap = sum(market_cap)) %>% 
mutate(day_before = lag(market_cap,1)) %>% 
  mutate(percent_change = (market_cap-day_before)/day_before) %>% 
  mutate(vol_group = rollapply(percent_change,30,sd,partial=TRUE)) %>% 
  drop_na() %>% group_by(trade_date,group)


