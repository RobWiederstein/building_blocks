library(sf)
library(leaflet)
library(leaflet.providers)
library(leafpop)
library(dplyr)

#Read in
counties <- readRDS("./in_counties.rds")
schools <- readRDS("./in_school_dist.rds")
providers <- readRDS("./sda_providers.rds")
# color <- c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E")
factpal <- leaflet::colorFactor(topo.colors(5), providers$provider)
#
numpal <- leaflet::colorNumeric(
	palette = RColorBrewer::brewer.pal(n = 5, "RdYlBu"),
	domain = schools$iread_pass_percent
)
# map
leaflet() %>%
	setView(-86.45713546504423, 38.56421435890006, zoom = 9) |>
	#base groups
	addProviderTiles("CartoDB.Positron") |>
	#overlay groups
	addPolygons(
		data = counties,
		fillOpacity = .2,
		weight = 1,
		stroke = T,
		opacity = 1,
		popup =  ~name,
		color = "#808080",
		group = "Counties"
	) |>
	addPolygons(
		data = schools,
		popup = leafpop::popupTable(
			schools,
			#zcol = c(4, 14:25),
			row.numbers = F
			),
		fillOpacity = .2,
		weight = 1,
		stroke = T,
		opacity = 1,
		color = ~numpal(schools$iread_pass_percent),
		group = "Schools"
		) |>
	addPolygons(
		data = providers,
		popup = leafpop::popupTable(
			providers,
			zcol = c(2, 3, 6:18),
			row.numbers = F
		),
		color = ~factpal(provider),
		group = "Providers"
	) |>
	#layer control
	addLayersControl(
		overlayGroups = c("Counties", "Schools", "Providers"),
		position = "topright",
		options = layersControlOptions(collapsed = FALSE)
	) |>
	# hide
	hideGroup(c("Counties", "Schools", "Providers"))
