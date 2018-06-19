#' export

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