library(shiny)
library(DT)

empty_set <- data.frame(Species = character(0), Sepal.Length= numeric(0))
saved_set <- iris[1:3, c(1, 5)]

shinyServer(function(input, output, session) {
  
  mydata <- reactiveValues(set_1 = empty_set,
                           set_2 = saved_set)
  
  errmsg <- eventReactive(input$addlib, {
    validate(
      need(input$newlib != "", "Library name cannot be empty"),
      need(!(input$newlib %in% names(mydata)), "Library name already exists")
    )
    mydata[[input$newlib]] <- empty_set
    updateTextInput(session, "newlib", value = "")
    NULL
  })
  
  output$errmsg <- renderText(errmsg())
  
  output$dTable <- renderDataTable({
    datatable(iris)
  })
  
  output$libs <- renderDataTable(({
    datatable(data.frame(Entity.Set = names(mydata),
                         Count = sapply(mydata, nrow)), 
              rownames = FALSE, selection = c("single"))
  }))
  
})