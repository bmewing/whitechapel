#' export

end_round = function(paths,hideouts=NULL){
  possible_hideouts = lapply(paths,function(x){
    rev(x)[1]
  })
  possible_hideouts = unique(unlist(possible_hideouts))
  if(is.null(hideouts)) return(sort(possible_hideouts))
  hideouts = intersect(hideouts,possible_hideouts)
  return(sort(hideouts))
}
