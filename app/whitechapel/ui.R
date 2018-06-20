library(shiny)

shinyUI(
  navbarPage(title="Advanced Policing Methods for Whitechapel",
    tabPanel(title="Dashboard",
      column(3,
        h3("Round Control"),
        uiOutput("currentRound"),
        actionButton("newRound",label="Start New Round"),
        selectInput("initialMurder","Murder Location",choices=1:195,multiple = TRUE),
        hr(),
        h3("Movement Control"),
        actionButton("basicMove",label="Basic Movement"),
        actionButton("carriageMove",label="Carriage"),
        actionButton("alleyMove",label="Alleyway"),
        hr(),
        h3("Investigation Control"),
        selectInput("spaceInvestigated","Space Investigated",choices=1:195,multiple=TRUE),
        radioButtons("investigationResult","Result",choices=list(`Nothing Found`=0,`Clue Found`=1))
      ),
      column(9,
        shiny::plotOutput("map")
      )
    )
  )
)
