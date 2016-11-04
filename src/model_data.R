# Fit a model of mandate claims

library(ProjectTemplate)
load.project()

# Refactor party
mandatesRef <- mandates %>%
  mutate(party = as.numeric(party) - 1.5,
         term_number = as.numeric(term_number) - 1.5)

# Fit a linear model
mandatesModel <- lm(mandate_claims ~ election_year + electoral_college_share + popular_vote_margin +
                      term_number + party + 
                      incoming_house_share + outgoing_house_share + incoming_house_share:outgoing_house_share +
                      incoming_senate_share + outgoing_senate_share + incoming_senate_share:outgoing_senate_share,
                    data = mandatesRef)

cat("Summary of the fitted model:\n")
print(summary(mandatesModel))

cat("--\n")
print(anova(mandatesModel))

# Plot the outliers of the model
fittedData <- augment(mandatesModel, mandates) %>%
  arrange(.cooksd) %>%
  mutate(row_id = row_number())

ggplot(fittedData, aes(row_id, .cooksd)) +
  geom_bar(stat = "identity") +
  scale_x_continuous(breaks = 1:nrow(fittedData),
                     labels = paste(fittedData$president, fittedData$election_year)) +
  coord_flip() +
  theme_classic() +
  theme(axis.ticks.y = element_blank()) +
  labs(x = "", y = "Cook's Distance",
       title = "Outliers in presidential mandate claims")
ggsave(file.path("graphs", "mandate_cooksd.png"), dpi = 96)
