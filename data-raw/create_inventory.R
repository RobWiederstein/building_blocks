#load inventory
ss <- 'https://docs.google.com/spreadsheets/d/1KW7f-9_-4aKaPCp6gRGDaB0eeRIhWaqwcyr9vZh-1eU/edit?usp=sharing'
df <- googlesheets4::read_sheet(
	ss = ss,
	sheet = "data_inventory"

) |>
	dplyr::mutate(created = as.Date(created)) |>
	dplyr::mutate(last_updated = as.Date(last_updated))
#load function
shinyButtons <- function(FUN, len, id, ...) {
	inputs <- character(len)
	for (i in seq_len(len)) {
		inputs[i] <- as.character(FUN(paste0(id, i), ...))
	}
	inputs
}
# add buttons
df.1 <-
	df |>
	dplyr::mutate(action =
			shinyButtons(
				FUN = shiny::actionButton,
				len = nrow(df),
				id = 'button_',
				label = "Preview",
				onclick = 'Shiny.onInputChange(\"select_button\",  this.id)'
			)
		)
saveRDS(df.1, "./data/inventory.rds")
