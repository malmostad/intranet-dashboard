# advice to upgrade browser.
# Include with IE conditional comment.
# Keep all content and css in this file instead of polluting the application
$ ->
  $(".wrapper").prepend("<div class='legacy-browser-warning warning'>
    <p>Din webbläsare är väldigt gammal och stöds inte längre i Komin.</p>
    <p>Uppgradera webbläsaren. Använder du en Malmö stad-dator, kontakta IT-support på 34 27 27.</p></div>")
  $(".legacy-browser-warning").css
    padding: ".6em 1em 0"
    marginBottom: "1em"
    fontSize: "15px"
    backgroundColor: "white"
