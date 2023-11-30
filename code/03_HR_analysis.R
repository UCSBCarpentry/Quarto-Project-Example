library(tidyverse)
library(BayesFactor)

#Read data
df <- read_csv("data/processed/preprocessed-GARP-TSST-data.csv")

#Convert df to long-format
df_long <- df %>%
  pivot_longer(cols = c(HR_Baseline_Average, HR_TSST_Average),
               names_to = "Measurement",
               values_to = "HR")

#Drop missing values
df_long <- df_long %>% drop_na(HR)

#Make sure columns are coded as factors for analysis
df_long$VPN <- as.factor(df_long$VPN)
df_long$Measurement <- as.factor(df_long$Measurement)
df_long$Condition <- as.factor(df_long$Condition)

#Bayesian Analysis
BF <- anovaBF(formula = HR ~ Measurement*Condition + VPN,
              data = df_long,
              whichRandom = "VPN")

#Evidence for interaction term
BF_interaction <- BF[4]/BF[3]

BF_interaction

#Summarize to mean / SEM for plot
df_long2 <- df_long %>%
  group_by(Measurement, Condition) %>%
  summarize(mean_value = mean(HR, na.rm = T),
            sem = sd(HR, na.rm = T)/sqrt(n()))

#Create plot
plot <- ggplot(df_long2, aes(Measurement, mean_value, group = Condition, color = Condition)) +
  geom_pointrange(aes(ymin=mean_value-sem, ymax= mean_value+sem)) +
  geom_line() +
  theme_classic() +
  scale_x_discrete(labels = c("Baseline",
                              "TSST-G/Control")) +
  ylab("Mean Heartrate (BPM)") +
  scale_colour_grey(start = 0.5, end = 0.2) +
  theme(legend.position = "top")

#Print and save plots  
plot

ggsave("output/heartrate.pdf", plot, width = 4, height = 3)
