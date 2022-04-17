#import ----
url <- 'https://www.in.gov/doe/files/school-enrollment-grade-2006-22.xlsx'
destfile <- paste0("~/Downloads/", basename(url))
download.file(url = url, destfile = destfile)
sheets <- readxl::excel_sheets(destfile)
# read ----
read_excel_allsheets <- function(filename) {
	sheets <- readxl::excel_sheets(filename)
	x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
	names(x) <- sheets
	x
}
l <- read_excel_allsheets(destfile)
# rename columns ----
col_names <- c(
	"corp_id",
	"corp_name",
	"schl_id",
	"schl_name",
	"pre_k",
	"kindergarten",
	paste0("grade_",1:12),
	"grade_12_plus_adult",
	"total_enrollment"
	)

for(i in seq_along(l)){
	colnames(l[[i]]) <- col_names
	l[[i]]$year <- names(l)[i]
}
# combine ----
enrollments <-
	data.frame(Reduce(rbind, l)) |>
	dplyr::select(year, everything()) |>
	dplyr::select(-total_enrollment) |>
	tidyr::pivot_longer(-(year:schl_name),
			    names_to = "enrollment",
			    values_to = "students"
			    ) |>
	dplyr::mutate(year = as.integer(year)) |>
	mutate(across(year, ~as.Date(paste0(.x, "-01-01"), format = "%Y-%m-%d")))
# reduce ----
enrollments_pre_k <-
	enrollments |>
	dplyr::filter(grepl("Vand|Warrick|Posey", corp_name)) |>
	dplyr::filter(grepl("pre_k", enrollment)) |>
	dplyr::group_by(year, corp_id) |>
	dplyr::summarize(total_pre_k = sum(students, na.rm = T))
# convert wide ----
enrollments_pre_k_wide <-
	enrollments_pre_k |>
	ungroup() |>
	pivot_wider(id_cols = year,
		    names_from = corp_id,
		    values_from = total_pre_k
	) |>
	dplyr::rename(vanderburgh = `7995`,
		      warrick = `8130`,
		      posey = `6600`)
# save ----
ss <- 'https://docs.google.com/spreadsheets/d/1KW7f-9_-4aKaPCp6gRGDaB0eeRIhWaqwcyr9vZh-1eU/edit?usp=sharing'
googlesheets4::write_sheet(
	enrollments_pre_k_wide,
	ss = ss,
	sheet = "in_pre_k"
)
saveRDS(enrollments_pre_k_wide, "./enrollments_pre_k.rds")
