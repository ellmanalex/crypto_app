

shinyServer(function(input, output,session) {

	observe({
		updateDateInput(session, 'start_date', 
			min = mdy('01-01-2016'), max = input$end_date[1])
		updateDateInput(session, 'end_date', 
			min = input$start_date[1], max = mdy('04-30-2020'))
		})

	group_data_reactive = reactive({
		group_data %>% filter(trade_date >= input$start_date[1] & 
		trade_date <= input$end_date[1]) %>% 
		filter(group %in% input$overview_groups)
		})

	output$historical_mp = renderPlotly({
		group_data_reactive() %>%
		ggplot(aes(x = trade_date, y = market_cap)) + 
		geom_line(aes(color = group)) + 
		stat_summary(fun.y = sum, color = 'black', geom = 'line', linetype = 'dashed') +
		ggtitle('Market Cap') + 
		scale_x_date(name = 'Trade Date') + 
		scale_y_continuous(name = 'Market Cap',labels = unit_format(unit = 'B', prefix = '$')) +
		guides(color = guide_legend(title = 'Cryptocurrencies'))
		})
	
	output$historical_v = renderPlotly({
		group_data_reactive() %>%
		ggplot(aes(x = trade_date, y = vol_group)) + 
		geom_line(aes(color = group)) +
		ggtitle('Volatility') + 
		scale_x_date(name = 'Trade Date') + 
		scale_y_continuous(name = 'Volatility') +
		guides(color = guide_legend(title = 'Cryptocurrencies'))
		})	





	})

