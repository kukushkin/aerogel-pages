class @AutofixedHeight
    constructor: (@element, @max_height_delta, @min_height_delta = @max_height_delta) ->
        @resize()
        $(window).on 'resize', @resize

    resize: =>
        wh = $(window).height()
        h = wh - @max_height_delta + 1
        @element.css 'max-height', h # outerHeight h
        h = wh - @min_height_delta + 1
        @element.css 'min-height', h # outerHeight h
        @element.height h # outerHeight h
        console?.log "** FixedHeightWatcher: element resized to #{h} (#{wh} - #{@max_height_delta})"


