library(readr)
library(mgsub)

pa_merge = function(x,y){
  merge(x,y,by='x',all.x = TRUE,all.y=TRUE)
}

process_answer = function(i,answers){
  a = answers[[i]]
  a = mgsub(a,c(" ","\\#","\\."),c("","",","))
  a = strsplit(a,",")
  r = do.call(`==`,lapply(a,function(x){
    nrow(cbind(i,x))
  }))
  return(r)
}

mturk_graph = read_csv("mturk_graph.csv")
answers = split(mturk_graph$Answer.connected
               ,mturk_graph$Input.target_node)
which(!unlist(lapply(1:195,process_answer,answers=answers)))
