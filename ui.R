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
          dateInput(inputId = 'start_date', label = 'From:', max = 'output$end_date'),
          dateInput(inputId = 'end_date', label = 'To:', min = 'output$start_date'),
          checkboxGroupInput(inputId = 'overview_groups', label = h4('Currencies to Display'), 
            choices = list('Bitcoin','Ethereum','Altcoins'))
        ),
        column(10,
          br(),
          br(),
          br(),
          plotOutput('historical_mp')
          )),
      fluidRow(
        column(2,""),
        column(10,
          plotOutput('historical_v')
          ))),
    tabPanel('Portfolio', icon = icon('wallet')
    )
  )
)
