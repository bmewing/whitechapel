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
  p = unique(unlist(roads[x == start | y == start]))
  p = p[p != start]
  return(lapply(p,add_possibilities,path=path))
}

add_possibilities = function(p,path){
  return(c(path,p))
}
