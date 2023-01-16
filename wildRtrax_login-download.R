#See the wildRtrax article here for more details on authentication: https://abbiodiversity.github.io/wildRtrax/articles/authenticating-into-wt.html

#1. Load packages----
# install.packages("remotes")
#remotes::install_github("ABbiodiversity/wildRtrax")

library(wildRtrax)
library(tidyverse)

#2. Login to WildTrax----
#NOTE: Edit the 'loginexample.R' script to include your WildTrax login details and rename to 'login.R'. DO NOT PUSH YOUR LOGIN TO GITHUB
config <- "login.R"
source(config)

wt_auth()

#3. Get list of projects from WildTrax----
projects <- wt_get_download_summary(sensor_id = 'ARU')

#4. Download RUGR dataset summary report----
dat.rugr <- wt_download_report(project_id = 1321, sensor_id = 'ARU', weather_cols = T, report = "summary")

#5. Download RUGR task report to check coordinate buffering----
task.rugr <- wt_download_report(project_id = 1321, sensor_id = 'ARU', report = "task")
table(task.rugr$buffer)

#6. Download multiple projects----
projects.test <- sample_n(projects, 3)

dat.list <- list()
error.log <- data.frame()
for(i in 1:nrow(projects.test)){
  
  dat.list[[i]] <- try(wt_download_report(project_id = projects.test$project_id[i], sensor_id = projects.test$sensorId[i], weather_cols = F, report = "summary"))
  
  print(paste0("Finished dataset ", projects.test$project[i], " : ", i, " of ", nrow(projects.test), " projects"))
  
}

dat.test <- do.call(rbind, dat.list)

#7. Save with metadata & timestamp----
save(dat, projects.test, error.log, file=paste0("Data/wildtrax_raw_", Sys.Date(), ".Rdata"))