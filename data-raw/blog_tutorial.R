#https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html
counties <- readRDS("./in_counties.rds")
library(leaflet)
library(dplyr)
#plot all ----
leaflet() %>%
	setView(-86.158164, 39.794474, zoom = 7) |>
	#base groups
	addTiles(group = "OSM (default)") |>
	addPolygons(
		data = counties,
		#popup = ~NAME,
		group = "Counties"
	)
#subset to counties ----
counties_subset <-
	counties |>
	dplyr::filter(name %in% c("Morgan", "Elkhart", "Vanderburgh"))
leaflet() %>%
	setView(-86.158164, 39.794474, zoom = 7) |>
	#base groups
	addTiles(group = "OSM (default)") |>
	addPolygons(
		data = counties_subset,
		popup = ~name,
		group = "Counties"
	)
#join counties by grouping ----
counties_join_by_group <-
	counties |>
	mutate(number = 1) |>
	group_by(statefp) |>
	summarize(tot = sum(number))
leaflet() %>%
	setView(-86.158164, 39.794474, zoom = 7) |>
	#base groups
	addTiles(group = "OSM (default)") |>
	addPolygons(
		data = counties_join_by_group,
		#popup = ~NAME,
		group = "Counties"
	)
# join counties ----
counties_join_by_union <- sf::st_union(counties)
leaflet() %>%
	setView(-86.158164, 39.794474, zoom = 7) |>
	#base groups
	addTiles(group = "OSM (default)") |>
	addPolygons(
		data = sf::st_union(counties),
		#popup = ~NAME,
		group = "Counties"
	)
# calculate centroids
# polygon ==> point
centroids <- sf::st_centroid(counties)
leaflet(centroids) |>
	setView(-86.158164, 39.794474, zoom = 7) |>
	#base groups
	addTiles(group = "OSM (default)") |>
	#layer groups
	addPolygons(data = sf::st_union(counties),
		    group = "State") |>
	addPolygons(data = counties,
		    group = "Counties") |>
	addMarkers(lat = unlist(lapply(centroids$geometry, "[[", 2)),
		   lng = unlist(lapply(centroids$geometry, "[[", 1)),
		   group = "Centroids"
	) |>
	#layer control
	addLayersControl(
		overlayGroups = c("State", "Counties", "Centroids"),
		position = "topright",
		options = layersControlOptions(collapsed = FALSE)
	) |>
	# hide
	hideGroup(c("State", "Counties", "Centroids"))

