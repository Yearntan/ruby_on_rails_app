// Import jQuery library
import $ from 'jquery';

// Wait for the DOM content to be fully loaded before executing the code
document.addEventListener("DOMContentLoaded", function() {
  // Find all elements with the "alert" class and apply fade out animation
  $(".alert").fadeTo(5000, 500).slideUp(500, function(){
    // Remove the element from the DOM after the animation completes
    $(this).remove(); 
  });
});
