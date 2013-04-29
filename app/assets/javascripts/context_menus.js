jQuery(document).ready(function($) {

  // Context menus for the boxes
  var $titleBars = $( 'body.user div.box h2' );

  if ( $titleBars.length ) {

    // Inject context menu buttons and attach event to open the menu
    $('<span class="menu-button">&#9662;</span>').prependTo($titleBars).click( function(event) {
      event.stopPropagation();
      var $menuButton = $(this);

      var $contextMenu = $menuButton.parent().siblings('div.context-menu');

      // Close menu if already open
      if ($contextMenu.hasClass('show')) {
        closeMenu($menuButton, $contextMenu);
      }
      else {
        // Close all menues before open this one
        $('div.context-menu').removeClass('show');
        $('h2 span.menu-button').removeClass('open');

        // Open this menu
        $contextMenu.addClass('show');
        $menuButton.addClass('open');

        // Hide on click outside the menu
        $(document).on('click', function(event) {
          closeMenu($menuButton, $contextMenu);
        });

        // Hide on escape key
        $(document).on('keyup', function(e) {
          if (e.which == 27) closeMenu($menuButton, $contextMenu);
        });

        // Execute command on menu selection
        $contextMenu.find('li').click(function(event){
          closeMenu($menuButton, $contextMenu);
          $boxContent = $contextMenu.siblings('.box-content');

          actions(this, $boxContent, $contextMenu);
        });
      }
    });
  }

  $titleBars.mouseenter(function() {
    $(this).find('span.menu-button').addClass('over');
  })
  .mouseleave(function() {
    $(this).find('span.menu-button').removeClass('over');
  });

  function closeMenu($menuButton, $contextMenu) {
    $contextMenu.find('li').off('click');
    $menuButton.removeClass('open over');
    $contextMenu.removeClass('show');
  }

  function actions(menuItem, $boxContent, $contextMenu) {
    var $menuItem = $(menuItem);

    switch ($menuItem.attr('data-action')) {
      case 'toggle':
        toggleBox($menuItem, $boxContent, $contextMenu);
        break;
      case 'reset':
        resetBox();
        break;
      case 'select-feeds':
        selectFeeds();
        // Do something more
        break;
    }
  }

  function toggleBox($menuItem, $boxContent, $contextMenu) {
    if ($boxContent.css('display') == 'block') {
      $boxContent.slideUp('fast');
      $menuItem.text('Visa');
    } else {
      $boxContent.slideDown('fast');
      $menuItem.text('Dölj');
    }
    $contextMenu.parent().toggleClass('closed');
  }

  function resetBox() {
    if (window.confirm('Vill du återställa inställningarna för den här boxen')) {
      document.location.reload();
    }
  }
  function selectFeeds() {
    document.location = '/feeds';
  }
});
