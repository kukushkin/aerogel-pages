#= require smart-tree-table
#= require_tree ./admin-pages
@pages_widget = null
pages_widget_height_fixer = null

$ =>
    @pages_widget = new TwoPaneWidget '.pages-widget', '.pane-tree', '.pane-preview'
    top_h = $("#top-menu").outerHeight()
    foot_h = $("#footer").outerHeight()
    pages_widget_height_fixer = new AutofixedHeight $('.pages-widget'), top_h+foot_h, top_h+ foot_h
    console?.log "** admin/pages loaded"