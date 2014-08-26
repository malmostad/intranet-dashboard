# advice to upgrade browser.
# Include with IE conditional comment.
# Keep all content and css in this file instead of polluting the application
$ ->
  $(".wrapper").prepend("<div class='legacy-browser-warning warning'>
    <p>Din webbläsare är väldigt gammal och stöds inte längre i Komin. Om du har Internet Explorer version 9 eller senare och får detta meddelande så är den felaktigt inställd så att den beter sig som version 7 eller 8 vilket kommer att skapa problem för dig när du använder den.</p>
    <p>Kontakta IT-support på 34 27 27 för att avhjälpa problemet.</p></div>")
  $(".legacy-browser-warning").css
    padding: ".6em 1em 0"
    marginBottom: "1em"
    fontSize: "15px"
    backgroundColor: "white"
