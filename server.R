

shinyServer(function(input, output,session) {

	group_data_reactive = reactive({
		group_data %>% filter(trade_date >= input$start_date[1] & 
		trade_date <= input$end_date[1]) #%>% 
		#filter(group %in% input$overview_groups)
		})

	output$historical_mp = renderPlotly({
		group_data_reactive() %>%
		ggplot(aes(x = trade_date, y = market_cap)) + 
		geom_line(aes(color = group)) + 
		stat_summary(fun.y = sum, color = 'black', geom = 'line', linetype = 'dashed') +
		ggtitle('Market Cap') + 
		scale_x_date(name = 'Trade Date') + 
		scale_y_continuous(name = 'Market Cap',labels = unit_format(unit = 'B', prefix = '$'))
		})
	
		





	})

