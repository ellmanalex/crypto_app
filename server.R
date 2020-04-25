

shinyServer(function(input, output,session) {

	group_data_reactive = reactive({
		group_data %>% filter(trade_date >= input$start_date & 
		trade_date <= input$end_date) %>% 
		filter(group %in% 'overview_groups')
		})

	output$historical_mp = renderPlotly({
		ggplot(group_data_reactive, aes(x = trade_date, y = summarise(sum(market_cap)/1000000000)) + 
		geom_line(aes(color = group)) + 
		stat_summary(fun.y = sum, color = 'black', geom = 'line', linetype = 'dashed') +
		ggtitle('Market Cap') + 
		scale_x_date(name = 'Trade Date') + 
		scale_y_continuous(name = 'Market Cap',labels = unit_format(unit = 'B', prefix = '$'))
		





	})

