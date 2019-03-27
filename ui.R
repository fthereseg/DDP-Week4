shinyUI(navbarPage("Forestry Production and Trade",
     tabPanel("Dynamics of avarage prices in a country",
        sidebarPanel(fluidRow = TRUE,
                sliderInput("range_years", label = h3("Range of years:"),
                            min = 1961, max = 2016, 
                            value = c(1990, 2016)),
                selectInput("country", label = h3("Country:"),
                            multiple = FALSE,
                            choices = unique(forestry_exp_prices$Area)),
                selectInput("product", label = h3("Product / Group of products:"),
                            multiple = FALSE,
                            choices = unique(forestry_exp_prices$Item))
         ),
            fluidRow(
                mainPanel(
                      plotOutput("export_prices_Plot")
                )
            )
      ),
     tabPanel("Dynamics of internal consuption in a country",
              sidebarPanel(fluidRow = TRUE,
                      sliderInput("range_years2", label = h3("Range of years:"),
                                  min = 1961, max = 2016, 
                                  value = c(1990, 2016)),
                      selectInput("country2", label = h3("Country:"),
                                  multiple = FALSE,
                                  choices = unique(forestry_int_consumption$Area)),
                      selectInput("product2", label = h3("Product / Group of products:"),
                                  multiple = FALSE,
                                  choices = unique(forestry_int_consumption$Item))
          ),
             fluidRow(
                mainPanel(
                     plotOutput("int_consumption_Plot")  
                )
             )
       ),

     tabPanel("Avarage prices by countries",
              sidebarPanel(
                      selectInput("year", label = h3("Year:"),
                                  multiple = FALSE,
                                  choices = unique(forestry_imp_prices$Year)),
                      selectInput("product3", label = h3("Product / Group of products:"),
                                  multiple = FALSE,
                                  choices = unique(forestry_imp_prices$Item))
              ),
              mainPanel(
                    plotOutput("import_prices_Plot") 
              )
      )
))
