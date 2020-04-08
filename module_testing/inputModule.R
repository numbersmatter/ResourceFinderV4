library(shiny)

filterDataInputsUI <- function(id, categories) {
  ns <- NS(id)
  
  tagList(
    selectInput(inputId = ns("category"),
                label = "Start by selecting a category:",
                choices = categories,
                multiple = TRUE,
                selectize = TRUE
                ),
    selectInput(inputId = ns("cities"),
                label = "Next, selection location(s):",
                choices = c("All Cities" = ''),
                multiple = TRUE,
                selectize = TRUE,
                selected = "All Cities"),
    selectInput(inputId = ns("programs"),
                label = "Finally, select program(s):",
                choices = c("All Programs" = ''),
                multiple = TRUE,
                selectize = TRUE)
    )
  
}

filterDataServer <- function(input, output, session, df) {
  
  # Create a filtered dataframe for category selection(s)
  cat_filt_df <- reactive({
    req(input$category)
    
    df %>%
      filter(Category %in% input$category)
  })
  
  # Observe reactive expression for filt_df and execute
  observe({
    city_choices <- cat_filt_df() %>%
          distinct(City) %>%
          pull(City)
    
    updateSelectInput(session, "cities",
                      label = "Next, selection location(s):",
                      choices = city_choices)
    })
  
  # Create reactive expression for program filtered dataframe
  pro_filt_df <- reactive({
    req(input$cities)
    
    cat_filt_df() %>%
      filter(City %in% input$cities)
  })
  
  # Observe program filtered dataframe reactive expression
  observe({
    pro_choices <- pro_filt_df() %>%
      distinct(Program) %>%
      pull(Program)
    
    updateSelectInput(session, "programs",
                      label = "Finally, select program(s):",
                      choices = pro_choices)
  })
  
  return(
    list(
      categories = reactive({ input$category }),
      cities = reactive({ input$cities }),
      programs = reactive({ input$programs})
      )
    )
  
}