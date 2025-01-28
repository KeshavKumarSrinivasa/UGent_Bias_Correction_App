library(shiny)
library(ggplot2)

mod_view_analysis_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Buttons to toggle between plots
    actionButton(ns("display1_btn"), "View Top 10 Coefficients"),
    # actionButton(ns("display2_btn"), "View SMD Table"),
    # actionButton(ns("display3_btn"), "View Volcano"),
    actionButton(ns("display4_btn"), "View ROC"),
    # UI output for the plot
    uiOutput(ns("plot_and_table_container"))
  )
}

mod_view_analysis_server <- function(id,r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Reactive value to store the selected plot index
    selected_display <- reactiveVal(1)

    analysis_results <- reactiveVal()

    analysis_results(perform_analysis(r))

    # Observers to update the selected plot based on button clicks
    observeEvent(input$display1_btn, {
      selected_display(1)
    })

    observeEvent(input$display2_btn, {
      selected_display(2)
    })

    observeEvent(input$display3_btn, {
      selected_display(3)
    })

    observeEvent(input$display4_btn, {
      selected_display(4)
    })

    # Render the UI containing the selected plot using switch()
    output$plot_and_table_container <- renderUI({
      display_id <- switch(
        selected_display(),
        `1` = "display1",
        `2` = "display2",
        `3` = "display3",
        `4` = "display4",
        "display1"  # Default case
      )

      if(as.integer(gsub("display","",display_id)) > 2){
        plotOutput(ns(display_id),height = 400,width = 800)
      }else{
        if(display_id=="display2"){
          tagList({
            div(
              style = "max-height: 350px; overflow-y: auto;",
              list(
                tableOutput(ns("display2_1")),
                tableOutput(ns("display2_2"))
              )
            )
          })


        }else{
          tableOutput(ns(display_id))
        }

      }
      # plotOutput(ns(display_id))

    })

    observe(
      {
        req(analysis_results())

        # # Render the first plot
        # output$display1 <- renderTable(trial_table())
        #
        # # Render the second plot
        # output$display2 <- renderTable(trial_table2())
        #
        # # Render the third plot
        # output$display3 <- renderPlot(trial_plot())
        #
        # # Render the fourth plot
        # output$display4 <- renderPlot(trial_plot2())


        r$output(analysis_results())
        # print(r$output()$multivariate_results$top_ten_coefficients)
        # print(names(r$output))

        # Render the first table
        output$display1 <- renderTable(r$output()$multivariate_results$top_ten_coefficients)

        # Render the second table smd before
        output$display2_1 <- renderTable(r$output()$smd_results$smd_before)

        # Render the second table smd after
        output$display2_2 <- renderTable(r$output()$smd_results$smd_after)

        # Render the volcano plot
        output$display3 <- renderPlot(r$output()$univariate_results$volcano_plot)

        # Render the roc plot
        output$display4 <- renderPlot(r$output()$multivariate_results$roc_plot)
      }
    )






})
}


