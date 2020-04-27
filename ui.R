library(shiny)
library(shinythemes)

fluidPage(
  theme = ('simplex'),
  navbarPage(
    title = 'Cryptocurrency Market', 
    id = 'nav',
    position = 'fixed-top',
    tabPanel('Overview', icon = icon('chart-line'),
      fluidRow(
        column(2,
          br(),
          br(),
          br(),
          h4('Select Date'),
          dateInput(inputId = 'start_date', label = 'From:', value = min(data$trade_date)),
          dateInput(inputId = 'end_date', label = 'To:', value = max(data$trade_date)),
          checkboxGroupInput(inputId = 'overview_groups', label = h4('Currencies to Display'), 
            choices = list('Bitcoin','Ethereum','Altcoins'), selected = list('Bitcoin','Ethereum','Altcoins'))
        ),
        column(10,
          br(),
          br(),
          br(),
          plotlyOutput('historical_mp')
          )),
      fluidRow(
        column(2,""),
        column(10,
          plotlyOutput('historical_v')
          ))),
    tabPanel('Portfolio', icon = icon('wallet'),
      fluidRow(
        column(2,
          br(),
          br(),
          br(),
          h4('Display Date'),
          dateInput(inputId = 'pc_start_date', label = 'From:', value = min(data$trade_date)),
          dateInput(inputId = 'pc_end_date', label = 'To:', value = max(data$trade_date)),
          br(),
          ),
        column(2,  
          br(),
          br(),
          br(),
          h4('Holding Dates'),
          dateInput(inputId = 'p_start_date', label = 'Buy:', value = mdy('01-01-2020')),
          dateInput(inputId = 'p_end_date', label = 'Sell:', value = max(data$trade_date)),
          ),
        column(8, align = 'center',
            br(),
            br(),
            br(),
            tableOutput('portfolio_table'),
            br()
          )),
      fluidRow(
        column(2,
          h4('Portfolio Selection'),
          selectizeInput('choice_1','Coin Selection 1', multiple = FALSE, choices = unique(data$ticker), selected = 'BTC'),
          numericInput(inputId = 'quantity_1', label = '$ Investment', value = 50, min = 0),
          selectizeInput('choice_2','Coin Selection 2', multiple = FALSE, choices = unique(data$ticker), selected = 'ETH'),
          numericInput(inputId = 'quantity_2', label = '$ Investment', value = 50, min = 0),
          selectizeInput('choice_3','Coin Selection 3', multiple = FALSE, choices = unique(data$ticker), selected = 'XRP'),
          numericInput(inputId = 'quantity_3', label = '$ Investment', value = 50, min = 0)
          ),
        column(2,
          br(),
          br(),
          selectizeInput('choice_4','Coin Selection 4', multiple = FALSE, choices = unique(data$ticker), selected = 'USDT'),
          numericInput(inputId = 'quantity_4', label = '$ Investment', value = 50, min = 0),
          selectizeInput('choice_5','Coin Selection 5', multiple = FALSE, choices = unique(data$ticker), selected = 'BCH'),
          numericInput(inputId = 'quantity_5', label = '$ Investment', value = 50, min = 0),
          selectizeInput('choice_6','Coin Selection 6', multiple = FALSE, choices = unique(data$ticker), selected = 'LTC'),
          numericInput(inputId = 'quantity_6', label = '$ Investment', value = 50, min = 0)
          ),
        column(8,
          plotlyOutput('portfolio_chart')
          )
        )
      )
    )
  )