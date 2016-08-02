###########
# Libraries
###########

library(RPostgreSQL)
library(digest)

##### Functions to connect R to GZ and Redshift
rs.host <- 'analytics-redshift.internal.atlassian.com'
rs.port <- 5439
rs.name <- 'dev'
rs.pass <- Sys.getenv('REDSHIFT_PASSWORD')
rs.user <- Sys.getenv('REDSHIFT_USERNAME')
gz.host <- 'greenzone-db.internal.atlassian.com'
gz.port <- 5432
gz.name <- 'greenzone'
gz.pass <- Sys.getenv('GREENZONE_PASSWORD')
gz.user <- Sys.getenv('GREENZONE_USERNAME')
drv <- dbDriver("PostgreSQL")
presto.host <- 'socrates.data.internal.atlassian.com'
presto.port <- 8081
presto.catalog <- 'hive'
presto.schema <- 'default'
presto.user <- Sys.getenv('PRESTO_USERNAME')

CacheExists <- function(sql, expiry.age=as.difftime("24", format="%H")) {
  
  cache.file <- paste("/tmp/sql-", digest(sql), ".dat", sep="")
  
  # on mac osx we can rely on launchd deleting files in /tmp for us eventually
  
  #   # flush the cache if the query is too old
  #   if(file.exists(cache.file) &
  #        file.info(cache.file)$ctime < (Sys.time() - expiry.age)){
  #    
  #     file.remove(cache.file)
  #   }
  
  return(file.exists(cache.file))
}
WriteCache <- function(sql, results) {
  
  cache.file <- paste("/tmp/sql-", digest(sql), ".dat", sep="")
  
  save(results, file=cache.file)
}
ReadCache <- function(sql) {
  
  cache.file <- paste("/tmp/sql-", digest(sql), ".dat", sep="")
  
  load(cache.file)
  return(results)
}
CacheOrQuery <- function(drv, db.host, db.port, db.name, db.user, db.pass,
                         sql, ...) {
  
  if(CacheExists(sql)) {
    
    rs <- ReadCache(sql)
    
  } else {
    
    #browser()
    
    tryCatch ({
      
      con <- dbConnect(drv, host=db.host, port=db.port, dbname=db.name,
                       user=db.user, password=db.pass)
      
    }, error = function(e) {
      
      stop(paste("Error connecting to db:", db.host, db.port, db.name, db.user,
                 rep("*", nchar(db.pass)), sep=" "))
    }
    )
    
    rs <- dbGetQuery(con, sql)
    
    if(! dbDisconnect(con)) {
      warning("Could not close connection")
    }
    
    WriteCache(sql, rs)
  }
  
  return(rs)
}

CacheOrQueryRedshift <- function(sql) {
  
  return(CacheOrQuery(drv, db.host=rs.host, db.port=rs.port, db.name=rs.name,
                      db.user=rs.user, db.pass=rs.pass, sql=sql))
  
}

CacheOrQueryGreenZone <- function(sql) {
  
  return(CacheOrQuery(drv, db.host=gz.host, db.port=gz.port, db.name=gz.name,
                      db.user=gz.user, db.pass=gz.pass, sql=sql))
}

CacheOrQueryPresto <- function(sql) {
  
  if(CacheExists(sql)) {
    
    rsp <- ReadCache(sql)
    
  } else {
    
    
    tryCatch ({
      
      con <- dbConnect(Presto(), host=presto.host, port=presto.port, catalog=presto.catalog,
                       schema=presto.schema, user=presto.user)
      
    }, error = function(e) {
      
      stop(paste("Error connecting to db:", presto.host, presto.port, catalog=presto.catalog, presto.user))
    }
    )
    
    rsp <- dbGetQuery(con, sql)
    
    if(! dbDisconnect(con)) {
      warning("Could not close connection")
    }
    
    WriteCache(sql, rsp)
  }
  
  return(rsp)
}
RunTests <- function() {
  
  rs <- data.frame(a=runif(20), b=rpois(20, 5))
  sql <- "select * from something"
  
  WriteCache(sql, rs)
  b <- rs
  rs <- NULL
  d <- ReadCache(sql)
  
  print(ifelse(identical(b, d), "round trip", "fail"))
  
  print(ifelse(CacheExists(sql), "cache exists", "fail"))
  
  Sys.sleep(2)
  
  print(ifelse(CacheExists(sql, expiry.age=as.difftime("1", format="%S")),
               "fail", "cache expired"))
  
}

# read the sql we need from a predictible location
GetGrowSql <- function (tag, units) {
  
  # find file containing sql query in a case insensitive manner
  sql.file <- list.files(path="AutomatedAnalysisReport/sql_files/", full.names=TRUE,
                         pattern=paste0("(?i)", tag, "-", units, "\\.sql"))[1]
  
  if( ! file.exists(sql.file) ) stop("Can't find file: ", sql.file)
  
  return(ReadFile(sql.file))
}
ReadFile <- function(file.name) {
  
  con <- file(file.name, "r")
  contents <- paste(readLines(con, -1), collapse="\n")
  close(con)
  return(contents)
}
############### END DB FUNCTIONS ################
