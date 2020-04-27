

shinyServer(function(input, output,session) {

	observe({
		updateDateInput(session, 'start_date', 
			min = mdy('01-01-2016'), max = input$end_date[1])
		updateDateInput(session, 'end_date', 
			min = input$start_date[1], max = mdy('04-30-2020'))
		updateDateInput(session, 'p_start_date', 
			min = mdy('01-01-2016'), max = input$end_date[1])
		updateDateInput(session, 'p_end_date', 
			min = input$start_date[1], max = mdy('04-30-2020'))
		updateDateInput(session, 'pc_start_date', 
			min = mdy('01-01-2016'), max = input$end_date[1])
		updateDateInput(session, 'pc_end_date', 
			min = input$start_date[1], max = mdy('04-30-2020'))

		currencies = unique(data$ticker)

		selection = c(input$choice_1[1], input$choice_2[1], input$choice_3[1], 
					input$choice_4[1], input$choice_5[1], input$choice_6[1])


		#updateSelectizeInput(session, 'choice_1', 
			#choices = currencies[currencies %in% selection[selection != input$choice_1] == FALSE])
		#updateSelectizeInput(session, 'choice_2', 
			#choices = currencies[currencies %in% selection[selection != input$choice_2] == FALSE])
		#updateSelectizeInput(session, 'choice_3', 
			#choices = currencies[currencies %in% selection[selection != input$choice_3] == FALSE])
		#updateSelectizeInput(session, 'choice_4', 
			#choices = currencies[currencies %in% selection[selection != input$choice_4] == FALSE])
		#updateSelectizeInput(session, 'choice_5', 
			#hoices = currencies[currencies %in% selection[selection != input$choice_5] == FALSE])
		#updateSelectizeInput(session, 'choice_6', 
			#choices = currencies[currencies %in% selection[selection != input$choice_6] == FALSE])

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
		guides(color = guide_legend(title = 'Currency'))
		})
	
	output$historical_v = renderPlotly({
		group_data_reactive() %>%
		ggplot(aes(x = trade_date, y = vol_group)) + 
		geom_line(aes(color = group)) +
		ggtitle('Volatility') + 
		scale_x_date(name = 'Trade Date') + 
		scale_y_continuous(name = 'Volatility') +
		guides(color = guide_legend(title = 'Currency'))
		})

	buy_price_1 = reactive({
		data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_1,5]
		})

	buy_price_2 = reactive({
		data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_2,5]
		})

	buy_price_3 = reactive({
		data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_3,5]
		})

	buy_price_4 = reactive({
		data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_4,5]
		})

	buy_price_5 = reactive({
		data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_5,5]
		})

	buy_price_6 = reactive({
		data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_6,5]
		})

	buy_quantity_1 = reactive({
		input$quantity_1/data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_1,5]
		})

	buy_quantity_2 = reactive({
		input$quantity_2/data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_2,5]
		})

	buy_quantity_3 = reactive({
		input$quantity_3/data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_3,5]
		})

	buy_quantity_4 = reactive({
		input$quantity_4/data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_4,5]
		})

	buy_quantity_5 = reactive({
		input$quantity_5/data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_5,5]
		})

	buy_quantity_6 = reactive({
		input$quantity_6/data[data$trade_date == input$p_start_date[1] & data$ticker == input$choice_6,5]
		})


portfolio_data = reactive({
		data %>% filter(ticker == input$choice_1 | 
			ticker == input$choice_2 | 
			ticker == input$choice_3 |
			ticker == input$choice_4 | 
			ticker == input$choice_5 | 
			ticker == input$choice_6) %>%
			mutate(buy_price = ifelse(ticker == input$choice_1, buy_price_1(),
							ifelse(ticker == input$choice_2, buy_price_2(),
							ifelse(ticker == input$choice_3, buy_price_3(),
							ifelse(ticker == input$choice_4, buy_price_4(),
							ifelse(ticker ==input$choice_5, buy_price_5(),
							ifelse(ticker == input$choice_6, buy_price_6(),0))))))) %>%
			mutate(buy_quantity = ifelse(ticker == input$choice_1, buy_quantity_1(),
							ifelse(ticker == input$choice_2, buy_quantity_2(),
							ifelse(ticker == input$choice_3, buy_quantity_3(),
							ifelse(ticker == input$choice_4, buy_quantity_4(),
							ifelse(ticker ==input$choice_5, buy_quantity_5(),
							ifelse(ticker == input$choice_6, buy_quantity_6(),0))))))) %>%
			mutate(owned_value = buy_quantity*price_usd) 
		})

chart_data = reactive({
		portfolio_data() %>% filter(trade_date >= input$pc_start_date[1] & 
		trade_date <= input$pc_end_date[1])
	})

output$portfolio_table = DT::renderDataTable({
	DT::datatable(portfolio_data() %>% filter(trade_date == input$p_end_date[1]) %>% 
	select(crypto_name, buy_quantity, buy_price, price_usd, owned_value, buy_quantity) %>% 
	mutate(return_dollars = owned_value - buy_price*buy_quantity, return_percent = ((price_usd-buy_price)/(buy_price)*100)) %>%
	#add_row(crypto_name = 'Portfolio', buy_quantity = NA, buy_price = sum(price_usd), return_dollars = 
		#sum(return_dollars), return_percent = (sum(price_usd)-sum(return_dollars))/sum(return_dollars)) %>%
	select('Cryptocurrency' = crypto_name, 'Buy Price' = buy_price, 'Sell Price' = price_usd, 'Return %' = 
		return_percent, 'Return $' = return_dollars), options = list(dom = 't')) %>% 
	formatRound(columns=c(2:5),digits=2)
	})

output$portfolio_chart = renderPlotly({
		chart_data() %>%
		ggplot(aes(x = trade_date, y = owned_value)) + 
		geom_line(aes(color = ticker)) + 
		#stat_summary(fun.y = sum, color = 'black', geom = 'line', linetype = 'dashed') +
		ggtitle('Portfolio Value') + 
		scale_x_date(name = 'Trade Date') + 
		scale_y_continuous(name = 'Portfolio Value',labels = unit_format(prefix = '$', unit = '')) +
		guides(color = guide_legend(title = 'Currency'))
		})

output$maindata = renderDataTable({
	data
})

	})

