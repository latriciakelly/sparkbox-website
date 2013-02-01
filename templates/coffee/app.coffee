# When you change APP, be sure to update it in mylibs/util.js
window.APP =

  init: ->
    @setBindings()
    @hero.init()

  setBindings: ->
    $( "#build-reveal" ).click ->
      $( "#build-header" ).toggleClass "bh-collapsed"

    $(".chain-icon").on "click", (e) ->
      $heroTeaser = $( ".hero-teaser" )
      $heroMore = $( ".hero-more" )
      $slider = $( ".hero" )
      $wrapper = $( ".hero-wrapper" )

      if !$slider.hasClass( "more-revealed" )
        console.log "leaving teaser, entering more"
        APP.hero.toggle( $heroTeaser, $heroMore )
      else
        console.log "leaving more, entering teaser"
        APP.hero.toggle( $heroMore, $heroTeaser )

  hero:

    init: ->
      $slider = $( ".hero" )
      $wrapper = $( ".hero-wrapper" )
      $heroMore = $( ".hero-more" )
      $heroTeaser = $( ".hero-teaser" )

      $heroMore.css
        #hide up out of view, out of flow
        "position": "absolute"
        "bottom": "100%"
        "width": "100%"

      $wrapper.on "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", (event) ->
        # if height is done transitioning
        if $( event.target ).is( $wrapper )

          if $slider.hasClass( "more-revealed" )
            $from = $( ".hero-teaser" )
            $to = $( ".hero-more" )
            console.log "entered hero-more"
          else
            $from = $( ".hero-more" )
            $to = $( ".hero-teaser" )
            console.log "entered hero-teaser"

          $to.css
            "position": "static"
          $slider.css
            "-webkit-transition": "none"
            "-webkit-transform": "translate3d( 0, 0, 0 )"

          $from.css
            #hide up out of view, out of flow
            "position": "absolute"
            "bottom": "100%"
            "width": "100%"


          $wrapper.css
            "-webkit-transition": "none"
            "height": "auto"

    toggle: ( $from, $to ) ->
      $slider = $from.parent() # slider does the sliding
      $wrapper = $slider.parent() # wrapper does the cropping

      $slider.toggleClass("more-revealed")

      $to.show()

      # get height values for $wrapper transition
      oldHeight = $from.outerHeight()
      newHeight = $to.outerHeight()

      # set fixed height on $wrapper
      $wrapper.height( oldHeight )

      # repaint
      $wrapper.height()

      # set transition
      $wrapper.css( "-webkit-transition", "height 0.4s" ) # this should use a css hook for other browsers

      # set new height
      $wrapper.height( newHeight )

      # (set height to auto on animation end with callback)
      # (event set in init())

      # slide to proper position
      $slider.css
        "-webkit-transition": "all 0.4s"
        "-webkit-transform": "translate3d( 0, #{newHeight}px, 0 )"

      # (set transform to 0 on animation end with callback)
      # (event in init())

$(document).ready ->
  UTIL.loadEvents
  APP.init()
