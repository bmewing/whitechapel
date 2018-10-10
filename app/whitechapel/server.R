library(shiny)
library(igraph)
library(shinyjs)
library(whitechapelR)
load("node_locations.rda")
load("roads.rda")
load("alley.rda")

shinyServer(function(input, output, session) {
   
  values = reactiveValues(paths=NULL,hideouts=NULL,blocked=NULL)
  
  observe({
    if(!is.null(input$initialMurder)){
      if(length(input$initialMurder) <= 2) enable("newRound") else disable("newRound")
    } 
    if(is.null(input$initialMurder)) disable("newRound")
  })
  
  output$currentRound = renderUI({
    if(input$newRound == 0){
      HTML("<strong><big>The game hasn't started yet</big></strong>")
    } else {
      HTML(paste0("<strong><big>Current Round: ",input$newRound,"</big></strong>"))
    }
  })
  
  observeEvent(input$newRound,{
    location = as.numeric(input$initialMurder)
    if(!is.null(values$paths)){
      if(!is.null(values$hideouts)){
        values$hideouts = end_round(values$paths,values$hideouts)
      } else {
        values$hideouts = end_round(values$paths)
      }
    }
    values$paths = start_round(location)
  })
  
  observeEvent(input$basicMove,{
    values$paths = take_a_step(values$paths,roads,values$blocked)
  })
  
  observeEvent(input$carriageMove,{
    values$paths = take_a_carriage(values$paths)
  })
  
  observeEvent(input$alleyMove,{
    values$paths = take_a_step(values$paths,alley)
  })
  
  observeEvent(input$submitInvestigation,{
    result = input$investigationResult=="1"
    values$paths = inspect_space(values$paths
                                 ,space = as.numeric(input$spaceInvestigated)
                                 ,clue = result)
  })
  
  observeEvent(input$addBlock,{
    bm = as.numeric(gsub(" +","",strsplit(input$blockedMovement,"[, ]+")[[1]]))
    if(length(bm) >= 2){
      if(length(bm) %% 2 == 1) bm = bm[-length(bm)]
      bp = lapply(seq(1,length(bm),by=2),function(x){
        bm[x:(x+1)]
      })
      values$blocked = unique(c(values$blocked,bp))
    }
    updateTextInput(session,inputId = "blockedMovement",value = "")
  })
  
  observeEvent(input$clearBlock,{
    values$blocked <- NULL
  })
  
  output$map = renderPlot({
    show_board(values$paths,values$hideouts,roads,alley,node_locations)
  })
  
  output$blockedPairs = renderTable({
    if(!is.null(values$blocked)){
      tbl = do.call(rbind,values$blocked)
      tbl[,1] = as.character(tbl[,1])
      tbl[,2] = as.character(tbl[,2])
    } else {
      tbl = NULL
    }
    tbl
  },colnames=FALSE)
})
