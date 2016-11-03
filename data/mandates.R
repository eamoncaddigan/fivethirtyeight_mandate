mandates <- read_html("http://fivethirtyeight.com/features/presidential-mandates-arent-real-but-congress-sometimes-acts-as-if-they-are/") %>% 
  html_node(xpath = "//*[@id=\"post-132914\"]/div/section/table") %>% 
  html_table()
