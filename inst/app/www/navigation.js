$(document).on('shiny:connected', function() {
  // Listen for "Go to Page 1" link click
  $(document).on('click', '#get_started', function() {
    Shiny.setInputValue('get_started', Math.random());
  });

  // Listen for "Continue" link click
  $(document).on('click', '#continue', function() {
    Shiny.setInputValue('continue', Math.random());
  });

  // Listen for "back" link click
  $(document).on('click', '#back1', function() {
    Shiny.setInputValue('back1', Math.random());
  });

  $(document).on('click', '#next3', function() {
    Shiny.setInputValue('next3', Math.random());
  });

    // Listen for "back" link click
  $(document).on('click', '#back2', function() {
    Shiny.setInputValue('back2', Math.random());
  });

  $(document).on('click', '#next4', function() {
    Shiny.setInputValue('next4', Math.random());
  });

    // Listen for "back" link click
  $(document).on('click', '#back3', function() {
    Shiny.setInputValue('back3', Math.random());
  });

  $(document).on('click', '#next5', function() {
    Shiny.setInputValue('next5', Math.random());
  });

    // Listen for "back" link click
  $(document).on('click', '#back4', function() {
    Shiny.setInputValue('back4', Math.random());
  });

  $(document).on('click', '#next6', function() {
    Shiny.setInputValue('next6', Math.random());
  });

      // Listen for "back" link click
  $(document).on('click', '#back5', function() {
    Shiny.setInputValue('back5', Math.random());
  });

  // Listen for "Back to Home" link click
  $(document).on('click', '#back_to_home', function() {
    Shiny.setInputValue('back_to_home', Math.random());
  });
});
