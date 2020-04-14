# Load packages
library(shiny)

# Define server logic
shinyServer(function(input, output, session) {
    
    ### begin address code
    my_address <- reactive({
        if(!is.null(input$jsValueAddressNumber)){
            if(length(grep(pattern = input$jsValueAddressNumber, x = input$jsValuePretty ))==0){
                final_address<- c(input$jsValueAddressNumber, input$jsValuePretty)
            } else{
                final_address<- input$jsValuePretty
            }
            final_address
        }
    })
    
    
    output$full_address <- renderText({
        if(!is.null(my_address())){
            my_address()
        }
    })
    
    output$lon_lat <- renderText({
        if(!is.null(my_address())){
            not_a_df2 <- google_geocode(address = my_address())
            my_coords2 <- geocode_coordinates(not_a_df2)
            my_coords3 <- c(my_coords2$lat[1], my_coords2$lng[1])
        }
    })
    
    
    ### end Address line
    
    observe({
        cities <- if( is.null(input$category)) character(0) else{
            filter(resources, Category %in% input$category)%>%
                `$`(`City`)%>%
                unique()
        }
        stillSelected <- isolate(input$cities[input$cities %in% cities])
        updateSelectizeInput(session, "cities", choices = cities,
                             selected = stillSelected, server= TRUE)
    })
    
    observe({
        programs <- if(is.null(input$cities)) character(0) else{
            filter(resources, 
                   City %in% input$cities,
                   Category %in% input$category)%>%
                `$`(`Program`)%>%
                unique()
        }
        stillSelected2 <- isolate(input$programs[input$programs %in% programs])
        updateSelectizeInput(session, "programs", choices = programs,
                             selected = stillSelected2, server = TRUE)
    })
    
    appdata <-reactive({
        resources %>%
            filter(
                is.null(input$category) | Category %in% input$category,
                is.null(input$cities) | City %in% input$cities,
                is.null(input$programs)  | Program %in% input$programs
            )
    })
    
    
    
    
    # Value Boxes
    output$programTotal <- renderValueBox({
        valueBox(
            paste0(nrow(resources)), "Total Programs", icon = icon("list"),
            color = "blue"
        )
        
    })
    output$programValue <- renderValueBox({
        valueBox(
            paste0(nrow(appdata())), "# of filtered Programs", icon = icon("list"),
            color = "green"
        )
    })
    
    # End Valueboxes
    
    output$table <- DT::renderDataTable({
        address_lat <- as.numeric(api_call$lat[1]())
        address_lon <- as.numeric(res$lon[1]() )
        df <- appdata()%>%
            select(
                Program,
                Organization,
                Category
            )
        
        df<- df%>%
            
            
            action <-
            DT::dataTableAjax(session, df, outputId = "table")
        
        DT::datatable(df, options = list(ajax = list(url = action), lengthMenu =c(5,10,15), pageLength = 5), escape = FALSE)
    })
    
    
    
    
    
    
    
    
    
    
    
    
    
    #leaflet map
    output$map <- renderLeaflet({
        if( !is.null(my_address())){
            
            addressholder <- google_geocode(address = my_address())
            
            addresslat <- addressholder$results$geometry$location$lat
            
            addresslon <- addressholder$results$geometry$location$lng
            
            
            df <- appdata()
            
            df<- add_row(df,
                         Lat= addresslat,
                         Lon =  addresslon,
                         Program = "test4"
            )
            
            df <- mutate(df,
                                 add_lon = addresslon,
                                 add_lat = addresslat,
                         
            )
            
            df <- mutate(df,
                         distance_miles = (distHaversine(df[,c("Lon", "Lat")],df[,c("add_lon", "add_lat")] ))/1609)
            
            df <- filter(df, distance_miles <2 )
            
            
            
          
         

        } else {
            
            # addressholder <- google_geocode(address = my_address())
            # 
            # addresslat <- addressholder$results$geometry$location$lat
            # 
            # addresslon <- addressholder$results$geometry$location$lng

            df <- appdata()
            
            df <- mutate(df,
                         home = FALSE)
            

        }
        
        
        
        
        
        
        leaflet() %>%
            addProviderTiles(provider = providers$CartoDB.Voyager)%>%
            addMarkers(data = df, lng = ~Lon, lat = ~Lat,
                       popup = str_c(df$Program, "<br>", df$Geoaddress, "<br>",
                                     "Hours Open:","<br>","Check Program box below."
                       ) 
            )
    })
    
    
    #programdata
    
    output$programinfo <- renderUI({
        lapply(1:nrow(appdata()), function(i){
            fluidRow(
                box(
                    width = 12,
                    title = paste0("A Program of: ", appdata()[i, 'Organization']),
                    h2(appdata()[i, 'Program']),
                    p("Address: ", str_to_title(appdata()[i,'Geoaddress']),
                      br(), 
                      "Phone: ", appdata()[i,'Phone'], br(),
                      "website: ", a(href= paste0(appdata()[i,'Website']), paste0(appdata()[i,'Website']) , target="_blank" )),
                    h3("Description"),
                    p(appdata()[i,'Description']),
                    h3("Changes to the Program Due to COVID-19"),
                    p(appdata()[i,'Notes']),
                    h4("Hours Open:"),
                    p("Monday: ", appdata()[i,'Mon'], br(), 
                      "Tuesday: ", appdata()[i,'Tue'],br(),
                      "Wednesday: ", appdata()[i,'Wed'],br(),
                      "Thursday: ", appdata()[i,'Thu'],br(),
                      "Friday: ", appdata()[i,'Fri'],br(),
                      "Saturday: ", appdata()[i,'Sat'],br(),
                      "Sunday: ", appdata()[i,'Sun'],br(),
                    )
                )
            )
        })
        
    })
    
    
  
    
    
})
browser() 
