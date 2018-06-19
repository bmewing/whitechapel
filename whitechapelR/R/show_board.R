#' export

show_board = function(paths=NULL,hideouts=NULL){
  r = roads
  a = alley
  r$lty = 1
  a$lty = 3
  r$weight = 1
  a$weight = 1
  l = as.matrix(node_locations[order(node_locations$name),c("x","y")])
  l[,2] = l[,2]*-1
  g = igraph::graph_from_data_frame(rbind(r,a),directed = FALSE)
  par(mai=c(0,0,0,0))
  V(g)$label.cex = 0.7
  if(!is.null(paths)){
    whrd = colorRampPalette(c("white","dark red"))
    colors = whrd(10)
    count = rep(0,195)
    tbl = table(unlist(paths))
    count[as.numeric(names(tbl))] = tbl
    V(g)$color = colors[as.numeric(cut(count,breaks=10))]
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
