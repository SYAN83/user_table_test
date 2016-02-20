library(shiny)
library(shinyBS)

shinyUI(
  navbarPage("Test App",
             tabPanel("Table",
                      fluidRow(
                        column(8, offset = 2,
                               h2("Test App"),
                               dataTableOutput("dTable"),
                               actionLink("additem", "Add to Entity Set"),
                               bsModal("additempanel", "Add Selections to Entity Set", 
                                       "additem", size = "large",
                                       uiOutput("bsModelui")
                               )
                        )
                      )
             ),
             tabPanel("Entity Sets",
                      fluidRow(
                        column(3, offset = 1,
                               uiOutput("selectset")),
                        column(7,
                               uiOutput("showset")
                               )
                      )
                      
             )
  )
)
