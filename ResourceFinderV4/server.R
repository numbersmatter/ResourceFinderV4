#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic
shinyServer(function(input, output, session) {
    
    observe({
        cities <- if( is.null(input$category)) character(0) else{
            filter(resources, Category %in% input$category)%>%
                `$`(`City`)%>%
                unique()
        }
        stillSelected <- isolate(input$city[input$city %in% cities])
        updateSelectizeInput(session, "city", choices = cities,
                             selected = stillSelected, server= TRUE)
    })

    observe({
        programs <- if(is.null(input$city)) character(0) else{
            filter(resources, 
                   City %in% input$city,
                   Category %in% input$category)%>%
                `$`(`Program`)%>%
                unique()
        }
        stillSelected2 <- isolate(input$program[input$program %in% programs])
        updateSelectizeInput(session, "program", choices = programs,
                             selected = stillSelected2, server = TRUE)
    })

    appdata <-reactive({
        resources %>%
            filter(
                is.null(input$category) | Category %in% input$category,
                is.null(input$city) | City %in% input$city,
                is.null(input$program)  | Program %in% input$program
            )
    })
    
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
    
    output$table <- DT::renderDataTable({
        df <- appdata()%>%
            select(
                Program,
                Organization,
                Category
            )
        
        action <-
            DT::dataTableAjax(session, df, outputId = "table")
        
        DT::datatable(df, options = list(ajax = list(url = action), lengthMenu =c(5,10,15), pageLength = 5), escape = FALSE)
    })
    
    #leaflet map
    output$map <- renderLeaflet({
        df <- appdata()
        
        
        
        leaflet() %>%
            addTiles() %>%
            addMarkers(data = df, lng = ~Lon, lat = ~Lat,
                       popup = str_c(df$Program, "<br>", df$GeoAddress, "<br>",
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
                p("Address: ", str_to_title(appdata()[i,'GeoAddress']),
                  br(), 
                  "Phone: ", appdata()[i,'Phone'], br(),
                  "website: ", a(href= paste0(appdata()[i,'Website']), paste0(appdata()[i,'Website']) , target="_blank" )),
                h3("Description"),
                p(appdata()[i,'Description']),
                h3("Notes"),
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
