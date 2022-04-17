# first steps data provider locations ----
ss <- 'https://docs.google.com/spreadsheets/d/1KW7f-9_-4aKaPCp6gRGDaB0eeRIhWaqwcyr9vZh-1eU/edit?usp=sharing'
df <- googlesheets4::read_sheet(
	ss = ss,
	sheet = "first_steps_providers"
)
saveRDS(input_file, "./data/first_steps_providers.rds")

