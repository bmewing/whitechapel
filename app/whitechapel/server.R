library(shiny)
library(igraph)
library(shinyjs)
load("node_locations.rda")
load("roads.rda")
load("alley.rda")

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

inspect_space = function(paths,space,clue){
  if(clue){
    paths = lapply(paths,found_clue,space=space)
  } else {
    paths = lapply(paths,found_nothing,space=space)
  }
  return(plyr::compact(paths))
}

found_clue = function(path,space){
  if(!any(path %in% space)) return(NULL)
  return(path)
}

found_nothing = function(path,space){
  if(any(path %in% space)) return(NULL)
  return(path)
}

show_board = function(paths=NULL,hideouts=NULL){
  r = roads
  a = alley
  r$lty = 1
  a$lty = 3
  r$weight = 1
  a$weight = 1
  l = as.matrix(node_locations[order(node_locations$name),c("x","y")])
  l[,2] = l[,2]*-1
  v = data.frame(name = 1:195,cex=0.7,color="white",stringsAsFactors = FALSE)
  g = igraph::graph_from_data_frame(rbind(r,a),directed = FALSE,vertices = v)
  par(mai=c(0,0,0,0))
  if(!is.null(paths)){
    colors = c("#FFD9D9","#F5C5C5","#ECB1B1","#E39D9D","#D98A8A","#D07676","#C76262","#BE4E4E","#B43B3B","#AB2727","#A21313","#990000")
    tbl = table(unlist(paths))
    to_replace = colors[round(tbl/max(tbl)*10,0)]
    col = V(g)$color
    col[as.numeric(names(tbl))] = to_replace
    V(g)$color = col
  }
  if(!is.null(hideouts)){
    shapes = rep("circle",195)
    shapes[hideouts] = "square"
    V(g)$shape = shapes
    col = V(g)$color
    col[hideouts] = "sky blue"
    V(g)$color = col
  }
  plot(g,layout=l,vertex.size = 5)
}

shinyServer(function(input, output) {
   
  values = reactiveValues(paths=NULL,hideouts=NULL)
  
  observe({
    print(length(input$initialMurder))
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
    values$paths = take_a_step(values$paths,roads)
  })
  
  observeEvent(input$carriageMove,{
    values$paths = take_a_carriage(values$paths,roads)
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
  
  output$map = renderPlot({
    show_board(values$paths,values$hideouts)
  })
  
})
