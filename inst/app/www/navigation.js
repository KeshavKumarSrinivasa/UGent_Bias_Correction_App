$(document).on('shiny:connected', function() {

  $(document).on('click', '#next_page', function() {
    Shiny.setInputValue('next_page', Math.random());
  });

  $(document).on('click', '#back', function() {
    Shiny.setInputValue('back', Math.random());
  });

});
