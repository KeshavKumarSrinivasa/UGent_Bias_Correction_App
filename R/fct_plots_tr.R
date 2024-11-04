#' plots_tr
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
plots <- eventReactive(c(input$n_obs,input$plot_num),{

  replicate(input$plot_num,{

    xmlSVG({hist(rnorm(input$n_obs),
                 col = 'darkgray',
                 border = 'white')},
           standalone=TRUE)

  },simplify = FALSE)
})
