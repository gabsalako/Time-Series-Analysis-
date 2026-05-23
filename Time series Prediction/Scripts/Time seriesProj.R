#load packages
library(tidyr)
library(ggplot2)
library(dplyr)
library(forecast)
library(mgcv)
library(here)
here()
#Clean aggregated dataset from 2001/2 - 2010
Year <- 2001:2010
Endogeic <-c(302, 3, 6, 250, 290, 307, 291, 350, 78, 40)
Epigeic <- c(190, 15, 25, 140, 14, 40, 219, 1, 13, 19)
Anecic <- c(52, 2, 3, 65, 72, 18, 75, 22, 12, 10)
#create dataframe
Ewts_data <- data.frame(Year, Endogeic, Epigeic, Anecic) 
print(Ewts_data)

#convert to long format and ensure all categorical variables are factors
Ewts_long <- Ewts_data %>%
  pivot_longer(cols = c(Endogeic, Epigeic, Anecic),
               names_to = "Species",
               values_to = "Abundance")
Ewts_long$Species <- as.factor(Ewts_long$Species)#ensure species is converted to factor var.

#Inspect long format dataframe 
print(Ewts_long)
#visualise 
plot(Ewts_long$Year, Ewts_long$Abundance,
     col = as.factor(Ewts_long$Species),
     pch = 16,
     xlab = "Year", ylab = "Abundance")
legend("topright", legend = levels(as.factor(Ewts_long$Species)),
       col = 1:3, pch = 16)
#fit gamm 
Ewts_model <- gamm(
  Abundance ~ Species + s(Year, by = Species, k = 5),
  random = list(Species = ~1),
  data = Ewts_long,
  family = poisson(link = "log")  # good for count data
)
summary(Ewts_model$gam)# R-sq.(adj) =   0.42 

#Visualization of the prediction across time line
plot(Ewts_model$gam, pages = 1, shade = TRUE)

# Soil fauna Recovery and Resistance Trajectory plots
ggplot(Ewts_long, aes(x = Year, y = Abundance, fill = Species)) +
  geom_area(alpha = 0.8, linewidth = 0.5, colour = "white") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal(base_size = 14) +
  labs(
    title = "Recovery and Resistance Trajectory",
    x = "Year (Successional Stage)",
    y = "Abundance",
    fill = "Ecological group"
  ) +
  theme(plot.title = element_text(face = "bold", size = 16))
