# Load packages
library(shiny)
library(shinydashboard)





# Define UI for shiny app
dashboardPage(
    
    dashboardHeader(title = "COVID-19 Resource Finder"),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem("Resources", tabName = "resources", icon = icon("th-list")),
            menuItem("Help Video", tabName = "helpVideo", icon = icon("play-circle")),
            
            selectInput(inputId = "category",
                        label = "Start by selecting a category:",
                        choices = unique(resources$Category),
                        multiple = TRUE,
                        selectize = TRUE
            ),
            selectInput(inputId = "cities",
                        label = "Next, selection location(s):",
                        choices = c("All Cities" = ''),
                        multiple = TRUE,
                        selectize = TRUE,
                        selected = "All Cities"),
            selectInput(inputId = "programs",
                        label = "Finally, select program(s):",
                        choices = c("All Programs" = ''),
                        multiple = TRUE,
                        selectize = TRUE) #,
            ,textInput(inputId = "my_address", label = "Type An Address")    
            ,textOutput(outputId = "full_address"),
            
            
            #feedback form
            br(),
            
            p(a(href="https://forms.gle/fBLCKun21bnEVw1i9", "Please give us feedback")),
            
            br(),
            
            
            p(a(href="https://forms.gle/gMVf1cbsrQs9wpdK8", "Suggest an Organization to Add"))
            
            #addressInputUI("address_input")
        ) #end sidebar menu
        
    ), # end sidebar
    
    dashboardBody(
        tags$head(includeHTML(("google-analytics.html"))),
        HTML(paste0(" <script>
                function initAutocomplete() {

var autocomplete =   new google.maps.places.Autocomplete(document.getElementById('my_address'),{types: ['geocode']});
                 autocomplete.setFields(['address_components', 'formatted_address',  'geometry', 'icon', 'name']);
                 autocomplete.addListener('place_changed', function() {
                 var place = autocomplete.getPlace();
                 if (!place.geometry) {
                 return;
                 }

                 var addressPretty = place.formatted_address;
                 var address = '';
                 if (place.address_components) {
                 address = [
                 (place.address_components[0] && place.address_components[0].short_name || ''),
                 (place.address_components[1] && place.address_components[1].short_name || ''),
                 (place.address_components[2] && place.address_components[2].short_name || ''),
                 (place.address_components[3] && place.address_components[3].short_name || ''),
                 (place.address_components[4] && place.address_components[4].short_name || ''),
                 (place.address_components[5] && place.address_components[5].short_name || ''),
                 (place.address_components[6] && place.address_components[6].short_name || ''),
                 (place.address_components[7] && place.address_components[7].short_name || '')
                 ].join(' ');
                 }
                 var address_number =''
                 address_number = [(place.address_components[0] && place.address_components[0].short_name || '')]
                 var coords = place.geometry.location;
                 //console.log(address);
                 Shiny.onInputChange('jsValue', address);
                 Shiny.onInputChange('jsValueAddressNumber', address_number);
                 Shiny.onInputChange('jsValuePretty', addressPretty);
                 Shiny.onInputChange('jsValueCoords', coords);});}
                 </script> 
                 <script src='https://maps.googleapis.com/maps/api/js?key=", api_key,"&libraries=places&callback=initAutocomplete' async defer></script>")),
        tabItems(
            
            tabItem(tabName = "resources",
                    # fluidRow(
                    #     column(width = 3),
                    #     box(width = NULL,
                    #         title = "YT Video Here",
                    #         HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/ScMzIvxBSi4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                    #     ),
                    fluidRow(
                        valueBoxOutput("programTotal"),
                        valueBoxOutput("programValue")
                    ), # closing fluidRow
                    fluidRow(
                        box(title = 'Map of Resources',
                            width = 12,
                            leafletOutput("map")),
                        uiOutput("programinfo")
                    ) # closing fluidRow
            ), # Closing resources tabItem
            tabItem(tabName = "helpVideo",
                    fluidRow(
                        box(
                            width = 8, status = "info", solidHeader = TRUE,
                            title = "Click on 'Resources' Tab to the left to jump to resources"
                            
                        ),
                    ),# end fluidRow
                    fluidRow(
                        column(width = 3),
                        box(width = NULL,
                            title = "Quick Start Video ",
                            HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/ScMzIvxBSi4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                        ),
                        column(width = 3)
                    ) # closing fluidRow
            ) # Closing helpVideo tabItem
        ) # Closing tabItems
    ) # Closing dashboardBody
) # Closing dashboardPage