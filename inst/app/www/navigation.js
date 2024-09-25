$(document).on('shiny:connected', function() {
  // Listen for "Go to Page 2" link click
  $(document).on('click', '#go_to_page2', function() {
    Shiny.setInputValue('go_to_page2', Math.random());
  });

  // Listen for "Back to Home" link click
  $(document).on('click', '#back_to_home', function() {
    Shiny.setInputValue('back_to_home', Math.random());
  });
});
