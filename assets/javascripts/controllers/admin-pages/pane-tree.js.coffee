# Left pane (tree) widget
#
tree_selector = "#tree"
tree_column = 2

log = (msg) ->
    console?.log "** admin/pages:tree: #{msg}"

class @PaneTree
    constructor: (@element) ->
        @tree_table = new SmartTreeTable @element.find( tree_selector ).first(),
            column: tree_column
            on_select: @on_tree_item_selected
            prefix:
                branch:
                    expanded: '<i class="prefix-expanded fa fa-caret-down"></i>'
                    collapsed: '<i class="prefix-collapsed fa fa-caret-right"></i>'
            dragAndDrop:
                enabled: false
                dropTarget:
                    overlay:
                        before: '<i class="fa fa-long-arrow-up"></i>'
                        into: '<i class="fa fa-long-arrow-right"></i>'
                        after: '<i class="fa fa-long-arrow-down"></i>'

        @select null

        @attached_footer = new AttachedFooter $(tree_selector), @bottom_toolbar(), $('.pane-tree .content')

        log "initialized"

    # Updates pane tree widget
    #
    update: (state) ->
        @tree_table.select state.page_id, false
        @scroll_to_view state.page_id
        @update_bottom_toolbar state
        @update_top_toolbar state

    select: (id) ->
        @tree_table.select id, false

    expand: (id) ->
        @tree_table.expand id

    scroll_to_view: (id) ->
        return unless id?
        row = @tree_table.rows[id]
        return unless row?
        el = row.el
        el_t = el.position().top
        el_b = el_t + el.height()
        if el_t < 0 || $('.pane-tree .content').height() < el_b
            origin_to = @tree_table.table.position().top
            scroll_to = el.position().top
            # console?.log "** pane-tree: scrolling to selected: #{scroll_to}: #{origin_to}"
            @element.find('.content').animate { scrollTop: scroll_to - origin_to } #, 'slow'


    # Callback to be invoked when page (tree item) is selected
    #
    on_tree_item_selected: (id, object, el) =>
        pages_widget.on_page_selected id, object


    # Returns row object specified by given +id+
    #
    find_row_by_id: (id) ->
        @tree_table.rows[id]

    # Returns action buttons elements, or elements within buttons specified by +selector+
    #
    bottom_toolbar: (selector = '') ->
        @element.find(".bottom-toolbar #{selector}")

    # Updates action buttons state and labels
    #
    update_bottom_toolbar: (state) ->
        unless state.page_id?
            @bottom_toolbar().hide()
            return
        object = @find_row_by_id state.page_id
        @bottom_toolbar().show()
        @bottom_toolbar('.page-append-link').attr 'href', pages_widget.url_to_action 'append'
        @bottom_toolbar('.page-insert-link').attr 'href', pages_widget.url_to_action 'insert'
        @bottom_toolbar('.page-delete-link').attr 'href', pages_widget.url_to_action 'delete'
        @bottom_toolbar(' .page-name').text object.contents
        @attached_footer.update_footer()

    # Returns top toolbar element, or elements within buttons specified by +selector+
    #
    top_toolbar: (selector = '') ->
        @element.find(".top-toolbar #{selector}")

    # Updates top toolbar buttons and links
    #
    update_top_toolbar: (state) ->
        @top_toolbar('.lang-select-link').each ->
            lang = $(@).attr 'data-lang-id'
            $(@).attr 'href', pages_widget.url_to( lang, state.page_id )


