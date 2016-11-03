# Join all of the data in prep for regression

# Add the presidents' party affiliation
mandates <- presidents %>%
  mutate(party = as.factor(party)) %>%
  left_join(mandates, ., by = "president")

# Add the share of the senate and house held by the newly-elected president's
# party. Look at both incoming and outgoing shares.
mandates <- congress %>% 
  rename(incoming = voted_in, outgoing = voted_out) %>% 
  gather("term", "election_year", incoming, outgoing) %>%
  unite(chamber, term, chamber, sep = "_") %>%
  mutate(chamber = paste0(chamber, "_share")) %>%
  spread(chamber, share) %>%
  left_join(mandates, ., by = c("party", "election_year"))

# Do a rudimentary average on the house and senate data to capture congressional
# share.
mandates <- mandates %>%
  mutate(incoming_congressional_share = (incoming_house_share+incoming_senate_share)/2,
         outgoing_congressional_share = (outgoing_house_share+outgoing_senate_share)/2)
