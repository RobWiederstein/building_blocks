# import ----
file <- 'https://www.in.gov/doe/files/2021-iread3-final-corporation-and-school-results.xlsx'
# fetch variable names ----
data_import <-
	rio::import(
	file = file,
	skip = 1
	) |>
	dplyr::rename_all(~janitor::make_clean_names(.x)) |>
	dplyr::rename(corp_name = corporation_name) |>
	dplyr::mutate(across(iread_pass_n, ~as.integer(.x))) |>
	dplyr::mutate(iread_pass_percent = `/`(iread_pass_n, iread_test_n) * 100) |>
	dplyr::mutate(across(iread_pass_percent, ~round(.x, 1))) |>
	dplyr::mutate(year = 2021)
iread3_scores <-
	data_import|>
	dplyr::select(year, corp_id, corp_name, iread_pass_percent)

# save as google sheet ----
ss <- 'https://docs.google.com/spreadsheets/d/1KW7f-9_-4aKaPCp6gRGDaB0eeRIhWaqwcyr9vZh-1eU/edit?usp=sharing'
googlesheets4::write_sheet(
	iread3_scores,
	ss = ss,
	sheet = "iread_3_scores"
)
saveRDS(iread3_scores, "./iread3_scores.rds")
