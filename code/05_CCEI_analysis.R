# Uncomment if libraries need to be loaded
#library(tidyverse)
#library(BayesFactor)

# Uncomment to Read data
# df <- read_csv("output/data/preprocessed-GARP-TSST-data.csv")

#Convert df to long-format
df_long <- df %>%
  pivot_longer(cols = c(CCEI_1, CCEI_2, CCEI_3),
               names_to = "Measurement",
               values_to = "CCEI")

#Drop missing values
df_long <- df_long %>% drop_na(CCEI, Date)

#Make sure columns are coded as factors for analysis
df_long$VPN <- as.factor(df_long$VPN)
df_long$Measurement <- as.factor(df_long$Measurement)
df_long$Condition <- as.factor(df_long$Condition)
df_long$Sex <- as.factor(df_long$Sex)

#Simple Bayesian Analysis without Covariates
BF <- anovaBF(formula = CCEI ~ Measurement*Condition + VPN,
        data = df_long,
        whichRandom = "VPN")

#Evidence for interaction term
BF_interaction <- BF[4]/BF[3]


#Include sex and age as covariates
BF2_intercept_only <- lmBF(formula = CCEI ~ VPN + Sex + Age,
                 data = df_long,
                 whichRandom = "VPN")

BF2_full <- lmBF(formula = CCEI ~ Measurement + Condition + Measurement:Condition + VPN + Sex + Age,
                 data = df_long,
                 whichRandom = "VPN")

BF2_nointeraction <- lmBF(formula = CCEI ~ Measurement + Condition + VPN + Sex + Age,
                          data = df_long,
                          whichRandom = "VPN")

#Evidence for interaction term
BF2_interaction <- BF2_full/BF2_nointeraction

#Summarize to mean / SEM for plot
df_long2 <- df_long %>%
  group_by(Measurement, Condition) %>%
  summarize(mean_value = mean(CCEI, na.rm = T),
            sem = sd(CCEI, na.rm = T)/sqrt(n()))

#Create plot for hormone
plot <- ggplot(df_long2, aes(Measurement, mean_value, group = Condition, color = Condition)) +
  geom_pointrange(aes(ymin=mean_value-sem, ymax= mean_value+sem)) +
  geom_line() +
  theme_classic() +
  scale_x_discrete(labels = c("Baseline",
                              "Early",
                              "Late")) +
  ylim(0.6,1) +
  scale_colour_grey(start = 0.5, end = 0.2) +
  theme(legend.position = "top") +
  ylab("CCEI")

#Print and save plot
plot
#ggsave("output/plots/ccei.pdf", plot, width = 4, height = 3)

