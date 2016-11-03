# The mandates data from fivethirtyeight is designed for display, not analysis.
# First, put in easier-to-use column names
colnames(mandates) <- c("president", "election_year", 
                        "electoral_college_share", "popular_vote_margin", 
                        "mandate_claims")

# Blank 'president' values should carry forward previous values.
mandates <- mandates %>%
  mutate(president = ifelse(president == "", NA, president)) %>%
  fill(president)

# We can ignore the note from 'election_year' and then convert to integer
mandates <- mandates %>%
  mutate(election_year = as.integer(sub("\\*$", "", election_year)))

# Convert the percentages to proportions
mandates <- mandates %>%
  mutate_each(funs(as.numeric(sub("%$", "", .))/100),
              electoral_college_share, mandate_claims)

# Add a term number
mandates <- mandates %>%
  group_by(president) %>%
  mutate(term_number = row_number(election_year)) %>%
  ungroup()

# FDR's 3rd and 4th terms were anomalous, so we'll exclude them from analysis.
mandates <- mandates %>%
  filter(term_number <= 2)

# Convert terms to factors
mandates <- mandates %>%
  mutate(term_number = as.factor(term_number))


