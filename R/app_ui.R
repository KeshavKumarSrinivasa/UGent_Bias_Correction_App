#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      uiOutput("pageContent")  # Dynamically display HTML content here
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")  # Set the path to your 'www' directory
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "repurpose"
    ),
    tags$script(src = "https://code.jquery.com/jquery-3.6.0.min.js"),  # Ensure jQuery is loaded
    tags$link(rel = "stylesheet", type = "text/css", href = "www/w3style.css")
  )
}


