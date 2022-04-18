# Data Warehouse

## Inputs {data-width=350 .sidebar}

At Building Blocks, we rely on timely, accurate data to benefit kids, parents, providers and community.  Much of the information is generated internally while some is created by others. Please confirm licensing terms with the owner prior to publishing the data.

```{r choose-dataset-dropdown, eval=T, include=T}
choices <-
	list(
		"US" =
			list("US Poverty Estimates" = "us_saipe_est"),
		"Indiana" =
			list(
				"First Steps Providers" = "first_steps_providers",
				"High School Graduation Rates" = "in_hs_grads",
				"IREAD-3 Results" = "iread_3_scores",
				"IN Pre-K Enrollments" = "in_pre_k"
			),
		"Building Blocks" =
			list(
				"Dataset 1" = "dataset1",
				"Dataset 2" = "dataset2"
			)

	)
h6("Choose Dataset:")
selectInput(
	inputId = "dataset",
	label = NULL,
	choices = choices
)
h6("Metadata:")
#textOutput("mytext")
tableOutput("inventory_metadata")
metadata <- reactive({
	#get dataset
	dataset <-
		inventory |>
		filter(sheet == input$dataset) |>
		select(owner:licensed) |>
		mutate(across(everything(), ~as.character(.x)))
	#transpose
	names <- names(dataset)
	df.1 <- matrix(dataset, dimnames = list(names, "value"))
	df.2 <- data.frame(names = row.names(df.1), df.1)
	df.2
})

output$inventory_metadata <-renderTable({
	metadata()
})

```

## Outputs

### Preview

```{r preview-dataset-ui, eval=T, include=T}
# create dataframe
data <- reactive({
	ss <- 'https://docs.google.com/spreadsheets/d/1KW7f-9_-4aKaPCp6gRGDaB0eeRIhWaqwcyr9vZh-1eU/edit?usp=sharing'
	df <- googlesheets4::read_sheet(
		ss = ss,
		sheet = input$dataset
	)
})
# show dataset
dataTableOutput("preview")
```

```{r preview-dataset-server, eval=F, include=F}
output$preview <- renderDataTable({
	DT::datatable(data(),
		      rownames = F,
		      extensions = 'Buttons',
		      options = list(
		      	dom = 'Bfrtip',
		      	buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
		      ),
		      class = "display"
	)
})
```

