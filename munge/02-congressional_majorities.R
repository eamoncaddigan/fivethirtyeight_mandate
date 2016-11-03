# Munge the Congressional data.

# First, we don't care about the years that congress is in session; we just care
# about the incoming and outgoing election years.
congress <- congress %>% 
  mutate(voted_in = as.integer(sub("^([0-9]{4}).*", "\\1", years))-1,
         voted_out = as.integer(sub(".*([0-9]{4})$", "\\1", years))-1)

# Find the democratic and republican share of the senate and house
congress <- congress %>% 
  gather("chamber_party", "seats", senate_democratic:house_vacancies) %>% 
  separate(chamber_party, c("chamber", "party")) %>% 
  group_by(years, chamber) %>%
  mutate(share = seats / sum(seats)) %>%
  ungroup()

# Get rid of the columns we won't use
congress <- congress %>%
  select(-congress, -years, -seats)

# We'll only consider Dems and Repubs
congress <- congress %>%
  filter(party %in% c("democratic", "republican")) %>%
  mutate(party = as.factor(party))
