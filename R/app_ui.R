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
  add_resource_path("www", app_sys("app/www"))

  tags$head(
    # Remove manually added Shiny JS and CSS if present
    # tags$link(rel = "stylesheet", type = "text/css", href = "shared/shiny.min.css"),
    # tags$script(src = "shared/shiny.min.js"),

    tags$link(rel = "stylesheet", type = "text/css", href = "www/w3style.css"),  # Your custom CSS
    favicon(),  # Add your favicon if needed
    bundle_resources(path = app_sys("app/www"), app_title = "repurpose")
  )
}
