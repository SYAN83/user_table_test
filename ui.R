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
                                       dataTableOutput("libs"),
                                       br(),
                                       column(6,
                                              actionLink("addtolib", "Add to selected Entity Set")
                                       ),
                                       hr(),
                                       fluidRow(
                                         column(8, textInput("newlib", NULL, "", width = "100%",
                                                             placeholder = "New Set")),
                                         column(4, actionLink("addlib", "Create new Entity Set"))
                                       ),
                                       uiOutput("errmsg")
                               )
                        )
                      )
               
             ),
             tabPanel("Entity Sets"
               
             )
  )
)
