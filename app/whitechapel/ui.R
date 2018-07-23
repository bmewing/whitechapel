library(shiny)
library(shinyjs)
library(shinythemes)

shinyUI(
  fluidPage(
             theme = "bootstrap.css",
            h1("Advanced Policing Methods for Letters from Whitechapel(R)"),
            hr(),
    fluidRow(
      column(3,
        h3("Round Control"),
        uiOutput("currentRound"),
        disabled(actionButton("newRound"
                            ,label="Start New Round"
                            ,icon=icon("play")
                            ,class="btn btn-lg btn-primary")),
        selectInput("initialMurder","Murder Location",choices=1:195,multiple = TRUE),
        hr(),
        h3("Movement Control"),
        actionButton("basicMove"
                    ,label="Basic Movement"
                    ,icon=icon("user-secret")
                    ,class="btn btn-lg btn-warning"),
        actionButton("carriageMove"
                    ,label="Carriage"
                    ,icon=icon("taxi")
                    ,class="btn btn-lg btn-danger"),
        actionButton("alleyMove"
                    ,label="Alleyway"
                    ,icon=icon("building")
                    ,class="btn btn-lg btn-danger"),
        br(),
        br(),
        h3("Movement Restriction"),
        "Here is where you can specify illegal movement for Jack by noting nodes which are blocked by policemen.",
        "Type node numbers by separating them with a space or a comma.",
        "If more than two nodes are input, they will processed as pairs.",
        br(),
        br(),
        textInput("blockedMovement","Blocked Movement",placeholder = "50,31,30,13"),
        actionButton("addBlock"
                    ,label="Add Block"
                    ,icon=icon("ban")
                    ,class="btn btn-lg btn-danger"),
        actionButton("clearBlock"
                    ,label="Clear Blocks"
                    ,icon=icon("unlock")
                    ,class="btn btn-lg btn-danger"),
        tableOutput("blockedPairs"),
        hr(),
        h3("Investigation Control"),
        selectInput("spaceInvestigated","Space Investigated",choices=1:195,multiple=TRUE),
        radioButtons("investigationResult","Result",choices=list(`Nothing Found`=0,`Clue Found`=1)),
        actionButton("submitInvestigation"
                    ,label="Submit"
                    ,icon=icon("search")
                    ,class="btn btn-lg btn-info")
      ),
      column(9,
        shiny::plotOutput("map",width="800px",heigh="800px"),
        useShinyjs()
      )
    )
  )
)
