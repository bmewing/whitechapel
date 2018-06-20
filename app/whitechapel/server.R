library(shiny)

roads = load("roads.rda")
alley = load("alley.rda")
node_locations = load("node_locations.rda")

start_round = function(initial_murder){
  #' @title Start a new round
  #' 
  #' @description Generate the initial list for a new round
  #' 
  #' @param initial_murder integer Space of the initial murder(s)
  
  l = list()
  l[[1]] = initial_murder[1]
  if(length(initial_murder) == 2) l[[2]] = initial_murder[2]
  return(l)
}

#' export

take_a_step = function(paths,roads){
  paths = lapply(paths,gen_possibilities,roads=roads)
  return(unlist(paths,recursive = FALSE))
}

#' export

take_a_carriage = function(paths,roads){
  paths = take_a_step(paths,roads)
  paths = take_a_step(paths,roads)
  return(paths)
}

gen_possibilities = function(path,roads){
  start = rev(path)[1]
  p = unique(unlist(roads[roads$x == start | roads$y == start,]))
  p = p[p != start]
  return(lapply(p,add_possibilities,path=path))
}

add_possibilities = function(p,path){
  return(c(path,p))
}

end_round = function(paths,hideouts=NULL){
  possible_hideouts = lapply(paths,function(x){
    rev(x)[1]
  })
  possible_hideouts = unique(unlist(possible_hideouts))
  if(is.null(hideouts)) return(sort(possible_hideouts))
  hideouts = intersect(hideouts,possible_hideouts)
  return(sort(hideouts))
}

shinyServer(function(input, output) {
   
  values = reactiveValues(paths=NULL,hideouts=NULL)
  
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
        values$hideouts = end_round(value$paths,values$hideouts)
      } else {
        values$hideouts = end_round(value$paths)
      }
    }
    values$paths = start_round(location)
  })
  
  observeEvent(input$basicMove,{
    values$paths = take_a_step(values$paths,roads)
    print(values$paths)
  })
  
})
