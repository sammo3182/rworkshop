#############Set up the first line ################################
# Time tracing
trace <- data.frame(start = NA, end = NA, spent = NA)
trace$start <- Sys.time() - 3600
trace$end <- Sys.time()
trace$spent <- difftime(trace$end,trace$start, units = "hours")
###################################################################

load("./timeTrace_hu.Rdata") # don't run at the first time, since the dataset hasn't been created yet

# run when at the starting point
trace_updated <- data.frame(start = NA, end = NA, spent = NA)
trace_updated$start <- Sys.time() 

save(trace, file = "./timeTrace_hu.Rdata")

# run this at the ending point
trace_updated$end <- Sys.time() 
trace_updated$spent <- difftime(trace_updated$end,trace_updated$start, units = "hours")

trace <- rbind(trace, trace_updated)
sum(trace$spent)

save(trace, file = "./timeTrace_hu.Rdata")


