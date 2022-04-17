# get geo ----
counties <- sf::read_sf(
	dsn = "./data/boundaries/cb_2020_us_county_20m",
	layer = "cb_2020_us_county_20m"
) |>
	sf::st_transform('+proj=longlat +datum=WGS84') |>
	sf::st_simplify() |>
	dplyr::filter(STATEFP == "18") |>
	dplyr::rename_all(~janitor::make_clean_names(.x))

# get sda territory -----
territory <- rio::import("./data-raw/sda_providers.xlsx",
			   sheet = "territories")

# add geographic counties
sda_territory <- left_join(counties, territory,  by = "name")
# merge counties into territories ----
providers <-
	sda_territory |>
	group_by(sda, provider) |>
	summarize(n_counties = n())
#import information
information <-  rio::import("./data-raw/sda_providers.xlsx",
			    sheet = "info")
# combine sheets of excel data
providers <- dplyr::left_join(providers, information, by = "provider")

# save ----
saveRDS(providers, "./sda_providers.rds")
