# Uncomment if libraries need to be loaded
#library(tidyverse)
#library(BayesFactor)
#library(patchwork)

#Read data
#df <- read_csv("output/data/preprocessed-GARP-TSST-data.csv")

#Define relevant column names
all_columns = list(
  c("Sv1_Cort", "Sv2_Cort", "Sv3_Cort", "Sv4_Cort", "Sv5_Cort", "Sv8_Cort", "Sv9_Cort"),
  c("Sv1_Amylase", "Sv2_Amylase", "Sv3_Amylase", "Sv4_Amylase", "Sv5_Amylase", "Sv8_Amylase", "Sv9_Amylase")
)

#Some utility strings for aesthetics of the plots
plot_units <- c("isol nmol/l", " U/ml")

#Create vectors for analyses results and plots
BFs <- c()
BFs_interaction <- c()
plots <- list()

#Keep count for plot placement in composed plot
count <- 1

#Loop through hormones
for (columns in all_columns) {
  
  #Convert df to long-format for relevant hormone
  df_long <- df %>%
    pivot_longer(cols = all_of(columns),
                 names_to = "Measurement",
                 values_to = "Value")
  
  #Define exclusion threshold (will only exclude one outlier data point in Cortisol)
  threshold <- mean(df_long$Value, na.rm = T) + 20*sd(df_long$Value, na.rm = T)
  
  #Print participant ID per excluded data point
  print(df_long %>% filter(Value > threshold) %>% select(VPN))
  
  #Drop missing values and filter by threshold
  df_long <- df_long %>%
    drop_na(Value) %>% 
    filter(Value < threshold)
  
  #Make sure columns are coded as factors for analysis
  df_long$VPN <- as.factor(df_long$VPN)
  df_long$Measurement <- as.factor(df_long$Measurement)
  df_long$Condition <- as.factor(df_long$Condition)
  
  #Bayesian Analysis
  BF <- anovaBF(formula = Value ~ Measurement*Condition + VPN,
                data = df_long,
                whichRandom = "VPN")
  
  #Evidence for interaction term
  BF_interaction <- BF[4]/BF[3]
  
  #Summarize to mean / SEM for plot
  df_long2 <- df_long %>%
    group_by(Measurement, Condition) %>%
    summarize(mean_value = mean(Value, na.rm = T),
              sem = sd(Value, na.rm = T)/sqrt(n()))
  
  #Create plot for hormone
  plot <- ggplot(df_long2, aes(Measurement, mean_value, group = Condition, color = Condition)) +
    geom_pointrange(aes(ymin=mean_value-sem, ymax= mean_value+sem)) +
    geom_line() +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 10, size = 9)) +
    scale_x_discrete(labels = c("Baseline 1", "Baseline 2", 
                                "TSST-G/Control",
                                "Early 1", "Early 2",
                                "Late 1", "Late 2")) +
    ylab(paste0(strsplit(columns[1], "_")[[1]][2], plot_units[count])) +
    scale_colour_grey(start = 0.5, end = 0.2)
  
  #Determine plot placement
  if (count != 1) {
    plot <- plot + theme(legend.position = "none")
  } else {
    plot <- plot + theme(legend.position = "top")}
  
  #Save data for later
  BFs <- c(BFs, BF)
  BFs_interaction <- c(BFs_interaction, BF_interaction)
  plots[[count]] <- plot
  count <- count + 1
} 

#Compose, print and save plots
hormone_plot <- plots[[1]] / plots[[2]]
hormone_plot
#ggsave("output/plots/hormones.pdf", hormone_plot, width = 6.3, height = 6.3)
