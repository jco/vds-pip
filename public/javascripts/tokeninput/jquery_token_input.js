// This uses the jquery.tokeninput.js file to set tokens on form fields
jQuery(document).ready(function($) {
  $("#project_token_field").tokenInput("/projects.json", {
    crossDomain: false,
    prePopulate: $(this).data("pre"),
    theme: "facebook"
  });
});