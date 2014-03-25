#= require smart-tree-table
#= require jquery.history
#= require_tree ./admin-pages
#

@pages_widget = null
pages_widget_height_fixer = null
@selected_page = null
@current_title = null
@history_processing = null

log = (msg) ->
    console?.log "** admin/pages: #{msg}"

@on_page_selected = (id, object) =>
    if id?
        @selected_page = object
    else
        @selected_page = null
    page_preview_show id, object
    url = if id? then "#{id}" else ""
    unless @history_processing?
        @history_processing = 'push'
        History.pushState({ url: url, selected_page_id: id }, @current_title, url)
        @history_processing = null
    log "page selected: #{id}"

@on_history_change = (state) =>
    unless @history_processing?
        @history_processing = 'pop'
        tree_select state.data.selected_page_id
        @history_processing = null

#
$ =>
    @current_title = document.title
    @pages_widget = new TwoPaneWidget '.pages-widget', '.pane-tree', '.pane-preview'
    top_h = $("#top-menu").outerHeight()
    foot_h = $("#footer").outerHeight()
    pages_widget_height_fixer = new AutofixedHeight $('.pages-widget'), top_h+foot_h #, top_h+ foot_h
    log "loaded"

    History.Adapter.bind window, 'statechange', =>
        on_history_change History.getState()
