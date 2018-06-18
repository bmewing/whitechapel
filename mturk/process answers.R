library(data.table)
library(magrittr)
library(mgsub)

load_data = function(){
  files = list.files('mturk'
                    ,pattern='.csv'
                    ,full.names = TRUE)
  output = lapply(files,fread) %>% 
    rbindlist()
  return(output)
}

process_answer = function(i,answers){
  a = answers[[i]]
  a = mgsub(a,c(" ","\\#","\\."),c("","",","))
  a = strsplit(a,",")
  r = Reduce(union,a)
  end = sort(as.numeric(r))
  start = rep(i,length(end))
  start[end < start] = end[end < start]
  end[start != i] = i
  return(data.table(start = start, end = end))
}

check_graph = function(){
  graph = fread("graph.csv")
  tmp = graph[verify == FALSE,list(start,end)]
  i = min(unlist(tmp))
  cat("Checking on",i,"\n")
  r = graph[start == i]
  r[order(start,end),list(start,end)]
}

fix_graph = function(add=NULL,remove=NULL){
  graph = fread("graph.csv")
  tmp = graph[verify == FALSE,list(start,end)]
  i = min(unlist(tmp))
  
  if(!is.null(remove)){
    to_remove = !((graph$start == i & graph$end %in% remove) | 
                    (graph$end == i & graph$start %in% remove))
    graph = graph[to_remove == TRUE]
  }
  if(!is.null(add)){
    start = rep(i,length(add))
    start[add < start] = add[add < start]
    add[start != i] = i
    graph = rbind(graph,data.table(start = start,end=add,verify=TRUE))
  }
  
  graph[start == i | end == i,verify := TRUE]
  
  fwrite(graph,"graph.csv")
  
  invisible(return(graph))
}

## Create initial graph --------
# mturk_graph = load_data()
# answers = split(mturk_graph$Answer.connected
#                ,mturk_graph$Input.target_node)
# graph = lapply(1:195,process_answer,answers=answers) %>% 
#   rbindlist()
# graph = unique(graph[start != 0])
# graph$verify = FALSE
# fwrite(graph,"graph.csv")

## Check graph ------
# check_graph()
# fix_graph(remove=c(NULL),add=c(NULL))
