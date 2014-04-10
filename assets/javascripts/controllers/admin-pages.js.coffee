#= require smart-tree-table
#= require jquery.history
#= require aerogel-media
#= require_tree ../admin-pages-utils
#= require_tree ../admin-pages


@pages_widget = null
@pane_tree = null
@pane_preview = null

$ =>
    @pages_widget = new PagesWidget $(".pages-widget"), $(".pane-tree"), $(".pane-preview")
    @pane_tree = new PaneTree $(".pane-tree").first()
    @pane_preview = new PanePreview $(".pane-preview").first()


