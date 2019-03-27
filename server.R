require(shiny)
require(data.table)
require(ggplot2)
require(plyr)
require(dplyr)
require(tidyr)
options(warn=-1)

# Main SERVER part
shinyServer(
        function(input, output) {
        
        output$export_prices_Plot <- renderPlot({
                filtered_exp <-
                        forestry_exp_prices %>%
                        filter(Year >= input$range_years[1],
                               Year <= input$range_years[2],
                               Item == input$product,
                               Area == input$country
                                )
                Unit <- subset(filtered_exp, Year == input$range_years[1] & 
                                                    Item == input$product & 
                                                    Area == input$country)
                Unit <- Unit$Unit[1]
                ggplot(filtered_exp, aes(Year, Export.Price)) +
                        geom_line(colour= "red",size=2)+
                        labs(title = paste("Avarage Export Prices of", input$product, "in", input$country)) +
                        labs(x = "Years", y = paste("Export Prices, USD/", Unit))+
                        scale_x_continuous(breaks = round(seq(min(filtered_exp$Year), max(filtered_exp$Year), by = 1),1))+
                        theme(plot.title = element_text(size=20, face="bold"))
          }, width = 1600)
        
        output$int_consumption_Plot <- renderPlot({
                filtered_consumption <-
                        forestry_int_consumption %>%
                        filter(Year >= input$range_years2[1],
                               Year <= input$range_years2[2],
                               Item == input$product2,
                               Area == input$country2
                        )
                Unit2 <- subset(filtered_consumption, Year == input$range_years2[1] & 
                                       Item == input$product2 & 
                                       Area == input$country2)
                Unit2 <- Unit2$Unit[1]
                ggplot(filtered_consumption, aes(Year, Int.Consumption)) +
                        geom_line(colour= "red",size=2)+
                        labs(title = paste("Internal consumption of", input$product2, "in", input$country2)) +
                        labs(x = "Years", y = paste("Internal consumption,", Unit2))+
                        scale_x_continuous(breaks = round(seq(min(filtered_consumption$Year), max(filtered_consumption$Year), by = 1),1))+
                        theme(plot.title = element_text(size=20, face="bold"))
          }, width = 1600)
        
        output$import_prices_Plot <- renderPlot({
                filtered_imp <-
                        forestry_imp_prices %>%
                        filter(Item == input$product3,
                               Year == input$year
                        )
                setorder(filtered_imp, Import.Price)
                filtered_imp$Area <- factor(filtered_imp$Area, levels = filtered_imp$Area)
  
                Unit3 <- subset(filtered_imp, Year == input$year & Item == input$product3)
                Unit3 <- Unit3$Unit[1]
                
                ggplot(filtered_imp, aes(Area, Import.Price)) +
                        geom_bar(stat = "identity",fill="steelblue") +
                        labs(title = paste("Avarage prices of", input$product3,"by countries")) +
                        labs(x = "Area", y = paste("Import prices, USD/", Unit3)) + 
                        coord_flip() +
                        geom_text(aes(label = round(Import.Price, digits = 0),hjust=-0.5)) +
                        theme(plot.title = element_text(size=20, face="bold"))
                

          }, width = 1400, height = 2500)       
    }
)