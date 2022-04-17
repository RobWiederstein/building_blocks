file <- 'https://www2.census.gov/programs-surveys/saipe/datasets/2020/2020-state-and-county/est20-in.txt'
df <-
	rio::import(
		file = file,
		header = F,
		fill = T,
		skip = 1
		)
df.1 <-
	df |>
	filter(!grepl("Kalb|Porte|Joseph", df$V25)) |>
	select(-V25, -V29)
colnames(df.1) <- paste0("V", 1:ncol(df.1))
#select columns
# 1 fips state
# 2 fips county
# 3 estimate of all people in poverty
# 6 estimated pct  of all people in poverty
# 9 estimate of 0-17 people in poverty
# 12 estimate pct of 0-17 in poverty
# 15 estimate 5-17 people in poverty
# 18 estimate 5-17 pct in poverty
# 21 estimate median household income
# 24 county
# 25 two letter state abbreviation
# 26 filename
# 27 date of creation
keep_cols <- c(1:3, 6, 9, 12, 15, 18, 21, 24:27)
df.1 <- df.1[, keep_cols]
col_names <-
	c(
		"state_fips",
		"county_fips",
		"est_all_num_pov",
		"est_all_pct_pov",
		"est_0-17_num_pov",
		"est_0-17_pct_pov",
		"est_5-17_num_pov",
		"est_5-17_pct_pov",
		"est_med_hh_income",
		"county_name",
		"state_abbr",
		"file_name",
		"date_created"
	)
colnames(df.1) <- col_names
ss <- 'https://docs.google.com/spreadsheets/d/1KW7f-9_-4aKaPCp6gRGDaB0eeRIhWaqwcyr9vZh-1eU/edit?usp=sharing'
df <- googlesheets4::write_sheet(
	df.1,
	ss = ss,
	sheet = "us_saipe_est"
)
