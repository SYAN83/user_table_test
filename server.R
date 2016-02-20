library(shiny)
library(DT)

data <- iris
empty_set <- data.frame(Species = character(0), Sepal.Length= numeric(0))
saved_set <- data[1:3, names(empty_set)]

shinyServer(function(input, output, session) {
  
  ## user's entity sets
  mydata <- reactiveValues(set_1 = empty_set,
                           set_2 = saved_set)

  ## data table output
  output$dTable <- renderDataTable({
    datatable(data)
  })
  
  ## add to Entity sets
  output$bsModelui <- renderUI({
    validate(
      need(!is.null(input$dTable_rows_selected), "No data was selected. \nTo add to a Entity set, please select your data First.")
    )
    list(
      dataTableOutput("libs"),
      br(),
      fluidRow(column(4,
                      actionLink("addtolib", "Add to selected Entity Set")),
               column(8,
                      textOutput("addtosetmsg"))),
      hr(),
      fluidRow(
        column(8, textInput("newlib", NULL, "", width = "100%",
                            placeholder = "New Entity Set")),
        column(4, actionLink("addlib", "Create new Entity Set"))
      ),
      uiOutput("errmsg")
    )
  })
  
  ## add new library Error handle  
  errmsg <- eventReactive(input$addlib, {
    validate(
      need(input$newlib != "", "Library name cannot be empty"),
      need(!(input$newlib %in% names(mydata)), "Library name already exists")
    )
    mydata[[input$newlib]] <- empty_set
    updateTextInput(session, "newlib", value = "")
    ""
  })
  
  output$errmsg <- renderText(errmsg())
  
  ## entity sets output
  mysets <- reactive({
    data.frame(Entity.Set = names(mydata),
               Count = sapply(names(mydata), function(x) nrow(mydata[[x]])))
  })
  
  output$libs <- renderDataTable({
    datatable(mysets(), 
              rownames = FALSE,
              selection = c("single"))
  })
  
  output$selectset <- renderUI({
   selectizeInput("selectedset", "My Entity Sets", names(mydata))
  })
  
  output$showset <- renderUI({
    validate(
      need(nrow(mydata[[input$selectedset]]) > 0, "Entity set is empty")
    )
    list(
      dataTableOutput("entitysettable"),
      actionLink("delrow", "Delete selected rows")
    )
  })
  
  output$entitysettable <- renderDataTable({
    datatable(mydata[[input$selectedset]])
  })
  
  observeEvent(input$delrow, {
    validate(
      need(input$entitysettable_rows_selected > 0, "No row has been selected")
    )
    mydata[[input$selectedset]] <- mydata[[input$selectedset]][-input$entitysettable_rows_selected,]
  })
  
  ## Selections add to entity set handle
  addtosetmsg <- eventReactive(input$addtolib, {
    validate(
      need(!is.null(input$libs_rows_selected), "Select an entity set to add.")
    )
    set_to_add <- mysets()[input$libs_rows_selected, 1]
    temp_tbl <- mydata[[set_to_add]]
    mydata[[set_to_add]] <- unique(rbind(temp_tbl,
                                         data[input$dTable_rows_selected,
                                              names(temp_tbl)]))

    return(paste(nrow(mydata[[set_to_add]]) - nrow(temp_tbl),
                 "row(s) has been added to", set_to_add))
  })
  
  output$addtosetmsg <- renderText(addtosetmsg())
  
})