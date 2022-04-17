#create school general data ----
file <- "https://www.in.gov/doe/files/2021-2022-school-directory-2022-02-02.xlsx"
schools <-
	rio::import(
		file = file,
		range = cellranger::cell_limits(c(1, 1), c(NA, 17))
	) |>
	dplyr::rename_all(~janitor::make_clean_names(.x)) |>
	dplyr::filter(grepl("School Corporation", corporation_type))
# add features ----
## import iread3 scores ----
file <- 'https://www.in.gov/doe/files/2021-iread3-final-corporation-and-school-results.xlsx'
data_import <-
	rio::import(
		file = file,
		skip = 1
	) |>
	dplyr::rename_all(~janitor::make_clean_names(.x)) |>
	dplyr::rename(corp_name = corporation_name,
		      idoe_corporation_id = corp_id) |>
	dplyr::mutate(across(iread_pass_n, ~as.integer(.x))) |>
	dplyr::mutate(iread_pass_percent = `/`(iread_pass_n, iread_test_n) * 100) |>
	dplyr::mutate(across(iread_pass_percent, ~round(.x, 1))) |>
	dplyr::mutate(year = 2021)
z_score <- function(x){(x - mean(x, na.rm = T)) / mean(x, na.rm = T)}
iread3_scores <-
	data_import|>
	dplyr::mutate(iread_z_score = z_score(iread_pass_percent)) |>
	dplyr::select(idoe_corporation_id, iread_pass_percent, iread_z_score)
## merge iread3 scores ----
schools <- dplyr::left_join(schools, iread3_scores, by = "idoe_corporation_id")
#create boundaries ----
districts <- sf::read_sf(
	dsn = "./data/boundaries/cb_2020_18_unsd_500k",
	layer = "cb_2020_18_unsd_500k"
	)  |>
	sf::st_transform('+proj=longlat +datum=WGS84') |>
	sf::st_simplify() |>
	dplyr::rename_all(~janitor::make_clean_names(.x)) |>
	tidyr::unite("nces_id", statefp:unsdlea, sep = "") |>
	dplyr::select(nces_id, geometry)
schools <- dplyr::left_join(districts, schools, by = "nces_id")
# format df for popup table ----
schools.formatted <-
	schools |>
	tidyr::unite(
		"superintendent",
		 superintendent_first_name:superintendent_last_name,
		sep = " "
		)
# save ----
saveRDS(schools.formatted, "./in_school_dist.rds")

