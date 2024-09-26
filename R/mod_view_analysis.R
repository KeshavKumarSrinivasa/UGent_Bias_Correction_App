mod_view_analysis_ui <- function(id) {
  ns <- NS(id)

  # Output the slickR carousel with PNG images
  slickROutput(ns("slickr_panel"), width = 800, height = 400)
}


mod_view_analysis_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Create a temporary directory to store the PNG files
    tmp_dir <- tempdir()

    # Generate the PNG images
    cached_plots <- reactiveVal(NULL)

    if (is.null(cached_plots())) {
      # List to store file paths of the generated PNGs
      png_files <- vector("list", length = 4)

      # Loop to generate 4 random PNG plots
      for (i in 1:4) {
        png_file <- file.path(tmp_dir, paste0("plot_", i, ".png"))
        png(png_file)  # Create PNG file with specified dimensions
        par(mar = c(4, 4, 1, 1))  # Set margins to avoid crowding
        plot(rnorm(100))  # Generate random plot
        dev.off()  # Close the PNG device to write the file
        png_files[[i]] <- png_file  # Store the file path in the list
      }

      # Cache the list of file paths
      cached_plots(png_files)
    }

    # Render slickR with the generated PNG images
    output$slickr_panel <- renderSlickR({
      slickR(cached_plots(), width = 800, height = 400) + settings(dots = TRUE)
    })
  })
}
