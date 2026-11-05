document.addEventListener("ajax:error", function(event) {
  var xhr = event.detail[2];
  switch(xhr.status) {
    // For 401 Unathorised responses, for example trying to making a
    // js request after a session timeout, reloading the current page
    // will redirect the user to the login page.
    case 401:
      location.reload();
      break;
    case 500:
      alert("Your request has unexpectedly failed (" + xhr.statusText + "). Please try again.");
  }
});
