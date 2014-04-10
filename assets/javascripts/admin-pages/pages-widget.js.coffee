#
#
log = (msg) ->
    console?.log "** admin/pages: #{msg}"


class @PagesWidget
    two_pane_widget: null
    current_state: {
        lang: 'en'
    }

    constructor: ( @element, @pane_left, @pane_right ) ->
        @two_pane_widget = new TwoPaneWidget @element, @pane_left, @pane_right
        top_h = $("#top-menu").outerHeight()
        foot_h = $("#footer").outerHeight()
        @height_fixer = new AutofixedHeight @element, top_h+foot_h #, top_h+ foot_h
        @current_title = document.title
        History.Adapter.bind window, 'statechange', =>
            @set_state History.getState().data

        @element.on 'changed.two-pane', (e, left_middle_right) =>
            @on_pane_open left_middle_right
        log "initialized"

    # Callback invoked by tree 'selected' event
    on_page_selected: ( id, object ) =>
        @current_state.page_id = id
        # @current_state.page_attributes = object.attributes
        @push_state()
        log "on_page_selected: id:#{@current_state.page_id}"


    # Callback invoked on pane open/close events
    on_pane_open: ( left_middle_right ) =>
        @current_state.open_pane = left_middle_right
        @push_state()

    # Go to page
    goto_page: (id) ->
        @current_state.page_id = id
        @push_state()

    push_state: ->
        # push current state to history,
        url = ''
        if @current_state.page_id?
            url = "#{@current_state.lang}-#{@current_state.page_id}"
        log "setting url to '#{url}'"
        log "setting lang '#{@current_state.lang}'"
        History.pushState( @current_state, @current_title, url )


    set_state: ( state ) ->
        log "set_state: id:#{state.page_id}"
        # console?.log state
        @current_state = state
        if state.page_id?
            row = pane_tree.find_row_by_id state.page_id
            @current_state.page_attributes = row.attributes
        @update @current_state

    update: ( state ) ->
        log "calling update(): id=#{state.page_id}"
        pane_tree.update state
        pane_preview.update state
        if state.open_pane == 'left'
            @two_pane_widget.open_left( false )
        else if state.open_pane == 'right'
            @two_pane_widget.open_right( false )
        else
            @two_pane_widget.open_middle( false )

    # Constructs url to +action+ on page specified by +lang+ and +id+
    #
    url_to: ( lang, id = '', action = null ) ->
        if action? then "#{lang}-#{id}/#{action}" else "#{lang}-#{id}"


    # Constructs url to +action+ on page specified by current state.
    #
    url_to_action: ( action ) ->
        @url_to( @current_state.lang, @current_state.page_id, action )
