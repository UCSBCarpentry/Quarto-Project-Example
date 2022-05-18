# Uncomment if libraries need to be loaded
#library(tidyverse)
#library(BayesFactor)

# Uncomment to Read data
df <- read_csv("output/data/preprocessed-GARP-TSST-data.csv", 
               encoding = "UTF-8")

df2 <- readxl::read_excel("data/online_data_cleaned.xlsx")

#Join data by participant ID
df_full <- df %>%
  full_join(df2, by="VPN")

#Scoring
df_full$BIS_2 <- 5 - df_full$BIS_2
df_full$BIS_22 <- 5 - df_full$BIS_22

df_full$SDS_1 <- 3 - df_full$SDS_1
df_full$SDS_5 <- 3 - df_full$SDS_5
df_full$SDS_6 <- 3 - df_full$SDS_6
df_full$SDS_10 <- 3 - df_full$SDS_10
df_full$SDS_14 <- 3 - df_full$SDS_14
df_full$SDS_16 <- 3 - df_full$SDS_16

df_full$BFI10_1 <- 6 - df_full$BFI10_1
df_full$BFI10_3 <- 6 - df_full$BFI10_3
df_full$BFI10_4 <- 6 - df_full$BFI10_4
df_full$BFI10_5 <- 6 - df_full$BFI10_5
df_full$BFI10_7 <- 6 - df_full$BFI10_7

df_full$QDQ_1 <- 6 - df_full$QDQ_1
df_full$QDQ_2 <- 6 - df_full$QDQ_2
df_full$QDQ_3 <- 6 - df_full$QDQ_3
df_full$QDQ_4 <- 6 - df_full$QDQ_4

df_full$MorEv_5 <- (df_full$MorEv_5 - 1)*2

mwtb_correct <- c(
  3,1,2,3,4,5,4,5,4,3,4,3,3,2,1,1,5,5,1,2,4,2,2,1,4,3,3,5,5,1,3,2,4,5,1,3,2
)

#Calculate summary scores
df_full$MWTB_Score <- df_full %>%
  select(MWT.B_1:MWT.B_37) %>%
  apply(1, function(x) {x == mwtb_correct}) %>%
  colSums(na.rm = T)


df_full <- df_full %>%
  mutate(SDS_Score = rowSums(select(.,SDS_1:SDS_16)),
         TICS_Score = rowSums(select(.,TICS_1:TICS_57)),
         QDQ_Score = rowSums(select(., QDQ_1:QDQ_10)),
         BFI_EV = rowSums(select(.,c(BFI10_1, BFI10_6))),
         BFI_Agree = rowSums(select(.,c(BFI10_2, BFI10_7))),
         BFI_Consc = rowSums(select(.,c(BFI10_3, BFI10_8))),
         BFI_Neuro = rowSums(select(.,c(BFI10_4, BFI10_9))),
         BFI_Open = rowSums(select(.,c(BFI10_5, BFI10_10))),
         BAS_Drive = rowSums(select(.,c(BIS_3, BIS_9, BIS_12, BIS_21))),
         BAS_Fun = rowSums(select(.,c(BIS_5, BIS_10, BIS_15, BIS_20))),
         BAS_Reward = rowSums(select(.,c(BIS_4, BIS_7, BIS_14, BIS_18, BIS_23))),
         BIS = rowSums(select(.,c(BIS_2, BIS_8, BIS_13, BIS_16, BIS_19, BIS_22, BIS_24))),
         Morningness = rowSums(select(.,MorEv_1:MorEv_5))
         )


#Test for group differences
bfAge <- ttestBF(formula = Age ~ Condition, data = df_full %>% drop_na(Age))
bfMWTB <- ttestBF(formula = MWTB_Score ~ Condition, data = df_full %>% drop_na(MWTB_Score))
bfSDS <- ttestBF(formula = SDS_Score ~ Condition, data = df_full %>% drop_na(SDS_Score))
bfTICS <- ttestBF(formula = TICS_Score ~ Condition, data = df_full %>% drop_na(TICS_Score))
bfQDQ <- ttestBF(formula = QDQ_Score ~ Condition, data = df_full %>% drop_na(QDQ_Score))
bfBFI_EV <- ttestBF(formula = BFI_EV ~ Condition, data = df_full %>% drop_na(BFI_EV))
bfBFI_Agree <- ttestBF(formula = BFI_Agree ~ Condition, data = df_full %>% drop_na(BFI_Agree))
bfBFI_Consc <- ttestBF(formula = BFI_Consc ~ Condition, data = df_full %>% drop_na(BFI_Consc))
bfBFI_Neuro <- ttestBF(formula = BFI_Neuro ~ Condition, data = df_full %>% drop_na(BFI_Neuro))
bfBFI_Open <- ttestBF(formula = BFI_Open ~ Condition, data = df_full %>% drop_na(BFI_Open))
bfMorningness <- ttestBF(formula = Morningness ~ Condition, data = df_full %>% drop_na(Morningness))
bfBIS <- ttestBF(formula = BIS ~ Condition, data = df_full %>% drop_na(BIS))
bfBAS_Drive <- ttestBF(formula = BAS_Drive ~ Condition, data = df_full %>% drop_na(BAS_Drive))
bfBAS_Fun <- ttestBF(formula = BAS_Fun ~ Condition, data = df_full %>% drop_na(BAS_Fun))
bfBAS_Reward <- ttestBF(formula = BAS_Reward~ Condition, data = df_full %>% drop_na(BAS_Reward))

bfSex <- contingencyTableBF(table(df_full %>% select(Condition, Sex)),
                            sampleType = "indepMulti",
                            fixedMargin = "rows")
bfUniversity <- contingencyTableBF(table(df_full %>% select(Condition, University_Education)),
                            sampleType = "indepMulti",
                            fixedMargin = "rows")

#Explorative: Test for Influence of Chronic Stress
corBfTICS <- correlationBF(df_full$TICS_Score, df_full$`CCEI_1`, nullInterval = c(0, 1))
samples <- posterior(corBfTICS[2], iterations = 10000)
summary(samples)

plot <- ggplot(df_full, aes(TICS_Score, `CCEI_1`)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = F, lty = 1, color = "black") +
  theme_classic() +
  xlim(50, 250) +
  ylim(0, 1) +
  xlab("TICS Score") +
  ylab("CCEI")

#Print and save plots
plot
#ggsave("output/plots/tics_ccei.pdf", plot, width = 4, height = 2)

#########################
#Descriptives
#########################

df_full %>% count(Condition)

df_full %>% group_by(Condition) %>% summarize(M = mean(Age), SD = sd(Age))

df_full %>% count(Condition, University_Education) %>% group_by(Condition)
df_full %>% count(Condition, Sex) %>% group_by(Condition)

df_full %>% group_by(Condition) %>% summarize(M = mean(TICS_Score), SD = sd(TICS_Score))
df_full %>% group_by(Condition) %>% summarize(M = mean(BFI_EV), SD = sd(BFI_EV))
df_full %>% group_by(Condition) %>% summarize(M = mean(BFI_Agree), SD = sd(BFI_Agree))
df_full %>% group_by(Condition) %>% summarize(M = mean(BFI_Consc), SD = sd(BFI_Consc))
df_full %>% group_by(Condition) %>% summarize(M = mean(BFI_Neuro), SD = sd(BFI_Neuro))
df_full %>% group_by(Condition) %>% summarize(M = mean(BFI_Open), SD = sd(BFI_Open))
df_full %>% group_by(Condition) %>% summarize(M = mean(BIS), SD = sd(BIS))
df_full %>% group_by(Condition) %>% summarize(M = mean(BAS_Drive), SD = sd(BAS_Drive))
df_full %>% group_by(Condition) %>% summarize(M = mean(BAS_Fun), SD = sd(BAS_Fun))
df_full %>% group_by(Condition) %>% summarize(M = mean(BAS_Reward), SD = sd(BAS_Reward))
df_full %>% group_by(Condition) %>% summarize(M = mean(QDQ_Score), SD = sd(QDQ_Score))
df_full %>% group_by(Condition) %>% summarize(M = mean(SDS_Score), SD = sd(SDS_Score))
df_full %>% group_by(Condition) %>% summarize(M = mean(Morningness), SD = sd(Morningness))