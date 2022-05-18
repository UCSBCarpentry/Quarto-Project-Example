# Uncomment if libraries need to be loaded
#library(tidyverse)
#library(stringi)
#source("analysis_scripts/functions/GARP_funcs.R")

#Read Mastersheet
df <- readxl::read_excel("data/GARP-TSST-mastersheet.xlsx")

#Loop over all Food Choice data files
dir <-"./data/foodchoice_data"
raw_files <- list.files(dir)

ccei_data <- c()

for (file in raw_files) {
  path <- file.path(dir, file)
  
  #Read file if possible, else skip
  raw_data <- tryCatch(raw_data <- read.csv(path, 
                                            stringsAsFactors=FALSE, 
                                            row.names = 1),
                       error = function(c) {"error"}
           )
  
  if (raw_data == "error") {
    raw_data <- tryCatch(raw_data <- read.csv(path,
                                              stringsAsFactors=FALSE, 
                                              row.names = 1,
                                              sep = ";"),
                         error = function(c) {"error"}
    )
  }
  
  if (raw_data == "error") {next}
  
  #Read out VPN and measurement
  vpn <- sample(raw_data$VP.Code, 1)
  measurement <- as.numeric(unlist(strsplit(file, "_"))[2])
  
  #Transpose data
  raw_data <- raw_data %>%
    select(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10)
  
  raw_data_t <- raw_data %>%
    t() %>%
    as.data.frame()
  
  colnames(raw_data_t) <- rownames(raw_data)
  
  #Calculate CCEI
  ccei <- raw_data_t %>%
    mutate(x = parse_number(sbundle),
           y = parse_number(stri_reverse(sbundle))) %>%
    summarise(ccei = CCEI(x, y, px, py, m)) %>%
    unlist()
  
  #Save data
  ccei_data <- rbind(ccei_data, c(vpn, measurement, ccei))
}

#Convert to wide format
colnames(ccei_data) <- c("VPN", "measurement", "ccei")
ccei_data <- ccei_data %>%
  as.data.frame() %>%
  pivot_wider(names_from = measurement,
              names_prefix = "CCEI_",
              values_from = ccei)

#Join Mastersheet & CCEI data
df_full <- df %>%
  full_join(ccei_data, by = "VPN")

#Save data to file
write.csv(df_full, "output/data/preprocessed-GARP-TSST-data.csv", 
          fileEncoding = "UTF-8", row.names = FALSE)