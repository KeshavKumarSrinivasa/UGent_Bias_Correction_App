#' save_plots_as_png
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
save_plots_as_png <- function(analysis_results) {

  tmp_dir <- tempdir()
  analysis_plots <- list(roc_plot = analysis_results$multivariate_results$roc_plot,
                         volcano_plot=analysis_results$univariate_results$volcano_plot)

  if (!is.null(analysis_plots)) {
    png_files <- vector("character", length = length(analysis_plots))  # List to store file paths

    # Loop through the ggplot objects and save them as PNGs
    for (i in seq_along(analysis_plots)) {
      png_file <- file.path(tmp_dir, paste0("plot_", i, ".png"))
      ggsave(filename = png_file, plot = analysis_plots[[i]], width = 8, height = 4, dpi = 300,bg = 'white')
      png_files[i] <- png_file  # Store file path in the list
    }
  }
  result_plots <- append(list(files = png_files), analysis_plots)
  return(result_plots)
}
