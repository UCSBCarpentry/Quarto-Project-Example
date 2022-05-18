# Uncomment if libraries need to be loaded
#library(tidyverse)

# Uncomment to Read data
#df <- read_csv("data/bronars_simulation_data.csv")

#Create plot
AI_quantiles <- quantile(df$AI, c(0.25, 0.5, 0.75))

AI_plot <- ggplot(df, mapping = aes(AI)) +
  geom_histogram(breaks=seq(0,1,0.1), color="white") +
  geom_vline(xintercept = AI_quantiles[1], lty=2, size=1.1)+
  geom_vline(xintercept = AI_quantiles[2], lty=1, size=1.1)+
  geom_vline(xintercept = AI_quantiles[3], lty=2, size=1.1)+
  xlim(0,1)+
  ylim(0, 3000)+
  xlab("CCEI")+
  ylab("Number of virtual subjects")+
  theme_classic()

#Print and save plot
AI_plot
#ggsave("output/plots/bronars.pdf", 
#       plot = AI_plot, device = "pdf",
#       scale = 1, width = 21, height = 7.5, units = "cm",
#       dpi = 600, limitsize = TRUE)