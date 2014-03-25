
debug = false
log = (msg) ->
    console?.log "** two-pane-widget: #{msg}" if debug
error = (msg) ->
    console?.error "** two-pane-widget: #{msg}" if debug
    throw new Error msg

class @TwoPaneWidget
    constructor: (@widget, @left_selector, @right_selector) ->
        @widget = $(@widget)
        @left_pane = @widget.find( @left_selector ).first()
        @right_pane = @widget.find( @right_selector ).first()
        @btn_open_left = @left_pane.find('.btn-open').first()
        @btn_open_right = @right_pane.find('.btn-open').first()
        @state = null
        @bind_event_listeners()
        @open_middle()
        log "widget created, left:#{@left_selector} right:#{@right_selector}"

    bind_event_listeners: ->
        @btn_open_left.on 'click', @on_open_left_clicked
        @btn_open_right.on 'click', @on_open_right_clicked

    on_open_left_clicked: =>
        log "open left clicked"
        if @state == 'middle'
            @open_left()
        else
            @open_middle()

    on_open_right_clicked: =>
        log "open right clicked"

        if @state == 'middle'
            @open_right()
        else
            @open_middle()

    open_left: ->
        return if @state == 'left'
        log "open left pane to full width"
        @open_pane @left_pane
        @close_pane @right_pane
        @state = 'left'

    open_right: ->
        return if @state == 'right'
        log "open right pane to full width"
        @open_pane @right_pane
        @close_pane @left_pane
        @state = 'right'

    open_middle: ->
        return if @state == 'middle'
        log "open panes to middle width"
        @half_open_pane @right_pane
        @half_open_pane @left_pane
        @state = 'middle'

    open_pane: (pane) ->
        pane.removeClass 'closed half-open'
        pane.addClass 'open'

    half_open_pane: (pane) ->
        pane.removeClass 'closed open half-open'
        pane.addClass 'half-open'

    close_pane: (pane) ->
        pane.removeClass 'closed open half-open'
        pane.addClass 'closed'
