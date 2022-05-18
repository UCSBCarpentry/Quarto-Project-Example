library(tidyverse)
library(BayesFactor)
library(patchwork)

#Read data
df <- read_csv("output/data/preprocessed-GARP-TSST-data.csv") %>%
  
  #Calculate sumscores for PANAS negative and positive affect scale
  #per measurement
  mutate(PANAS_PA_1 = rowSums(select(.,PANAS1_1, PANAS1_3, PANAS1_4, PANAS1_6, 
                          PANAS1_10, PANAS1_11, PANAS1_13, PANAS1_15, 
                          PANAS1_17, PANAS1_18)),
         PANAS_PA_2 = rowSums(select(.,PANAS2_1, PANAS2_3, PANAS2_4, PANAS2_6, 
                          PANAS2_10, PANAS2_11, PANAS2_13, PANAS2_15, 
                          PANAS2_17, PANAS2_18)),
         PANAS_PA_3 = rowSums(select(.,PANAS3_1, PANAS3_3, PANAS3_4, PANAS3_6, 
                          PANAS3_10, PANAS3_11, PANAS3_13, PANAS3_15, 
                          PANAS3_17, PANAS3_18)),
         PANAS_PA_4 = rowSums(select(.,PANAS4_1, PANAS4_3, PANAS4_4, PANAS4_6, 
                          PANAS4_10, PANAS4_11, PANAS4_13, PANAS4_15, 
                          PANAS4_17, PANAS4_18)),
         PANAS_PA_5 = rowSums(select(.,PANAS5_1, PANAS5_3, PANAS5_4, PANAS5_6, 
                          PANAS5_10, PANAS5_11, PANAS5_13, PANAS5_15, 
                          PANAS5_17, PANAS5_18)),
         PANAS_PA_6 = rowSums(select(.,PANAS6_1, PANAS6_3, PANAS6_4, PANAS6_6, 
                          PANAS6_10, PANAS6_11, PANAS6_13, PANAS6_15, 
                          PANAS6_17, PANAS6_18)),
         PANAS_NA_1 = rowSums(select(.,PANAS1_2, PANAS1_5, PANAS1_7, PANAS1_8, 
                          PANAS1_9, PANAS1_12, PANAS1_14, PANAS1_16, 
                          PANAS1_19, PANAS1_20)),
         PANAS_NA_2 = rowSums(select(.,PANAS2_2, PANAS2_5, PANAS2_7, PANAS2_8, 
                          PANAS2_9, PANAS2_12, PANAS2_14, PANAS2_16, 
                          PANAS2_19, PANAS2_20)),
         PANAS_NA_3 = rowSums(select(.,PANAS3_2, PANAS3_5, PANAS3_7, PANAS3_8, 
                          PANAS3_9, PANAS3_12, PANAS3_14, PANAS3_16, 
                          PANAS3_19, PANAS3_20)),
         PANAS_NA_4 = rowSums(select(.,PANAS4_2, PANAS4_5, PANAS4_7, PANAS4_8, 
                          PANAS4_9, PANAS4_12, PANAS4_14, PANAS4_16, 
                          PANAS4_19, PANAS4_20)),
         PANAS_NA_5 = rowSums(select(.,PANAS5_2, PANAS5_5, PANAS5_7, PANAS5_8, 
                          PANAS5_9, PANAS5_12, PANAS5_14, PANAS5_16, 
                          PANAS5_19, PANAS5_20)),
         PANAS_NA_6 = rowSums(select(.,PANAS6_2, PANAS6_5, PANAS6_7, PANAS6_8, 
                          PANAS6_9, PANAS6_12, PANAS6_14, PANAS6_16, 
                          PANAS6_19, PANAS6_20))
         )

#Define relevant column names
all_columns = list(
  c("PANAS_PA_1", "PANAS_PA_2", "PANAS_PA_3", "PANAS_PA_4", "PANAS_PA_5", "PANAS_PA_6"),
  c("PANAS_NA_1", "PANAS_NA_2", "PANAS_NA_3", "PANAS_NA_4", "PANAS_NA_5", "PANAS_NA_6"),
  c("VAS1_1", "VAS2_1", "VAS3_1", "VAS4_1", "VAS5_1", "VAS6_1"),
  c("VAS1_2", "VAS2_2", "VAS3_2", "VAS4_2", "VAS5_2", "VAS6_2"),
  c("VAS1_3", "VAS2_3", "VAS3_3", "VAS4_3", "VAS5_3", "VAS6_3"),
  c("VAS1_4", "VAS2_4", "VAS3_4", "VAS4_4", "VAS5_4", "VAS6_4")
)

#Some utility strings for aesthetics of the plots
plot_units <- c("Positive Affect (PANAS)", " Negative Affect (PANAS)",
                "Stressed (VAS)", "Ashamed (VAS)", "Insecure (VAS)", "Self-Secure (VAS)")

#Create vectors for analyses results and plots
BFs <- c()
BFs_interaction <- c()
plots <- list()

#Keep count for plot placement in composed plot
count <- 1

#Loop through scales
for (columns in all_columns) {
  
  #Convert df to long-format for relevant scale
  df_long <- df %>%
    pivot_longer(cols = all_of(columns),
                 names_to = "Measurement",
                 values_to = "Value")
  
  #Drop missing values
  df_long <- df_long %>% drop_na(Value)
  
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
  
  #Create plot for scale
  plot <- ggplot(df_long2, aes(Measurement, mean_value, group = Condition, color = Condition)) +
    geom_pointrange(aes(ymin=mean_value-sem, ymax= mean_value+sem)) +
    geom_line() +
    theme_classic() +
    theme(axis.text.x = element_text(angle = 10, size = 10)) +
    scale_x_discrete(labels = c("Baseline",
                                "TSST-G/Control",
                                "Early 1", "Early 2",
                                "Late 1", "Late 2")) +
    ylab(plot_units[count]) +
    scale_colour_grey(start = 0.5, end = 0.2)
  
  #Determine plot placement
  if (count != 2) {
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
selfreport_plot <- wrap_plots(plots, nrow = 3)
selfreport_plot
#ggsave("output/plots/selfreport.pdf", selfreport_plot, width = 9.8, height = 7.2)

