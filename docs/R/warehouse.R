library(shiny)
library(DT)
inventory <- readRDS("./data/inventory.rds")
# ui ----
ui <- function(id){
	fillPage(
		fillCol(
			DT::dataTableOutput("dataset_inventory"),
			DT::dataTableOutput("dataset_preview")
			#verbatimTextOutput("dataset_preview")
		)
	)
}
# server ----
server <- function(input, output) {
	## create empty dataset ----
	myValue <- reactiveValues(dataset = '')
	## load data inventory ----
	df <- reactiveValues(data = inventory)
	## data inventory >> datatable
	output$dataset_inventory <-
		DT::renderDataTable(
			df$data,
			server = FALSE,
			escape = FALSE,
			selection = 'none',
			filter = 'top',
			extensions = "Buttons",
			options = list(
				pageLength = 5,
				autoWidth = TRUE,
				columnDefs = list(list(visible=FALSE, targets=c(5, 8, 10)))
			)
		)
	## select dataset  ----
	observeEvent(input$select_button, {
		selectedRow <- as.numeric(strsplit(input$select_button, "_")[[1]][2])
		myValue$dataset <<- df$data[selectedRow, 10] |> dplyr::pull()
	})
	# create preview -----
	output$dataset_preview <- renderDataTable({
		if(is.null(input$select_button)){
			print(data.frame())
		}else{
			ss <- 'https://docs.google.com/spreadsheets/d/1KW7f-9_-4aKaPCp6gRGDaB0eeRIhWaqwcyr9vZh-1eU/edit?usp=sharing'
			df <- googlesheets4::read_sheet(
				ss = ss,
				sheet = myValue$dataset
			)
			DT::datatable(
				df,
				extensions = 'Buttons',
				options = list(
					dom = 'Bfrtip',
					buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
				),
				class = "display"
			)
		}
	})
}
shiny::shinyApp(ui, server)
