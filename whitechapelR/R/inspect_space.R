#' export

inspect_space = function(paths,space,clue){
  if(clue){
    paths = lapply(paths,found_clue,space=space)
  } else {
    paths = lapply(paths,found_nothing,space=space)
  }
  return(plyr::compact(paths))
}

found_clue = function(path,space){
  if(!any(path == space)) return(NULL)
  return(path)
}

found_nothing = function(path,space){
  if(any(path == space)) return(NULL)
  return(path)
}