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
            choices = list('Bitcoin','Ethereum','Altcoins'))
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
    tabPanel('Portfolio', icon = icon('wallet')
    )
  )
)
