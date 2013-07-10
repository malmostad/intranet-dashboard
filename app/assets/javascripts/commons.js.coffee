$ ->
  # Temporarily disable zoom on text field focus
  if $(window).width() <= 480
    viewportContent = $("meta[name=viewport]").attr("content")
    $('input')
      .focus () ->
        $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=1')
      .blur () ->
        $("meta[name=viewport]").attr("content", viewportContent + ', maximum-scale=10')
