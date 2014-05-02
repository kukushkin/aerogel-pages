# Left pane (tree) widget
#
tree_selector = "#tree"
tree_column = 3

log = (msg) ->
    console?.log "** admin/pages:tree: #{msg}"

class @PaneTree
    constructor: (@element) ->
        @tree_table = new SmartTreeTable @element.find( tree_selector ).first(),
            column: tree_column
            on_select: @on_tree_item_selected
            on_tree_change: @on_tree_changed
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

        @attached_footer = new AttachedFooter
            target: $(tree_selector)
            footer: @bottom_toolbar()
            observe: $('.pane-tree .content')

        @pages_reorder_enabled = false
        $("body").on "click", "A.pages-reorder-link", (e) =>
            e.preventDefault()
            pages_widget.on_pages_reorder_started()

        $("body").on "click", ".pages-reorder-save-link", (e) =>
            e.preventDefault()
            log "** save reordered pages"
            for row in @ordered_row_list()
                log "** #{row.id}: parent:#{row.parent_id}"

        log "initialized"

    # Updates pane tree widget
    #
    update: (state) ->
        log "** update:"
        @tree_table.select state.page_node_id, false
        if !!state.pages_reorder_enabled && !@pages_reorder_enabled
            @tree_table.enable_drag_and_drop()
            @pages_reorder_enabled = true
            log "** pages reorder enabled!"
        @scroll_to_view state.page_node_id
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
        if object?
            allowed_children = @row_allowed_children_types object
            console?.log "** tree item selected: #{object.attr 'type'} -> #{allowed_children.length}:#{allowed_children}"
        pages_widget.on_page_selected id, object

    # Callback to be invoked when pages (tree branches/leaves) are reordered
    #
    on_tree_changed: () =>
        log "** tree changed!"
        form = @bottom_toolbar('.pages-reorder-actions form').first()
        form.find("input.page_nodes").remove()
        for row in @ordered_row_list()
            parent_id = if row.parent_id? then row.parent_id else ''
            form.append("<input type='hidden' name='page_nodes[#{row.id}][parent_id]' value='#{parent_id}' class='page_nodes'/>")
            log "** #{row.id}: parent:#{row.parent_id}"


    # Returns row object specified by given +id+
    #
    find_row_by_id: (id) ->
        @tree_table.rows[id]

    # Returns ordered list of rows as objects with +id+, +parent_id+
    #
    ordered_row_list: ->
        { id: row.id, parent_id: row.parent_id } for row in @tree_table.rows_list()

    # Returns array of allowed children types for the row object
    #
    row_allowed_children_types: (row) ->
        return [] unless row?
        s = row.attr 'allowed-children'
        allowed_children = if s then s.split ',' else []
        allowed_children


    # Returns action buttons elements, or elements within buttons specified by +selector+
    #
    bottom_toolbar: (selector = '') ->
        @element.find(".bottom-toolbar #{selector}")

    # Updates action buttons state and labels
    #
    update_bottom_toolbar: (state) ->
        unless state.page_node_id? || @pages_reorder_enabled
            log "** update_bottom_toolbar: disabling"
            @bottom_toolbar().hide()
            return
        row = @find_row_by_id state.page_node_id
        parent_row = if row? then @find_row_by_id row.parent_id else null
        @bottom_toolbar().show()
        if @pages_reorder_enabled
            @bottom_toolbar('.pages-reorder-actions').show()
            @bottom_toolbar('.page-actions').hide()
        else
            @bottom_toolbar('.pages-reorder-actions').hide()
            if state.page_node_id?
                @bottom_toolbar('.page-actions').show()

                if parent_row?
                    # nested page selected
                    allowed_children = @row_allowed_children_types parent_row
                    if allowed_children.length > 1
                        # append multiple
                        @bottom_toolbar('.page-append-link').hide()
                        @bottom_toolbar('.page-append-select-link').show()
                        @bottom_toolbar('.page-append-select-link').attr 'href',
                            pages_widget.url_to_action "append_select"
                    else if allowed_children.length > 0
                        # append single
                        @bottom_toolbar('.page-append-select-link').hide()
                        @bottom_toolbar('.page-append-link').show()
                        @bottom_toolbar('.page-append-link').attr 'href',
                            pages_widget.url_to_action "append?page_type=#{allowed_children}"
                    else
                        # no append
                        @bottom_toolbar('.page-append-link').hide()
                        @bottom_toolbar('.page-append-select-link').hide()

                    @bottom_toolbar('.page-delete-link').show()
                    @bottom_toolbar('.page-delete-link').attr 'href', pages_widget.url_to_action 'delete'
                else
                    # root selected
                    @bottom_toolbar('.page-append-link').hide()
                    @bottom_toolbar('.page-append-select-link').hide()
                    @bottom_toolbar('.page-delete-link').hide()

                if row?
                    allowed_children = @row_allowed_children_types row
                    if allowed_children.length > 1
                        # insert multiple
                        @bottom_toolbar('.page-insert-link').hide()
                        @bottom_toolbar('.page-insert-select-link').show()
                        @bottom_toolbar('.page-insert-select-link').attr 'href',
                            pages_widget.url_to_action "insert_select"
                    else if allowed_children.length > 0
                        # insert single
                        @bottom_toolbar('.page-insert-select-link').hide()
                        @bottom_toolbar('.page-insert-link').show()
                        @bottom_toolbar('.page-insert-link').attr 'href',
                            pages_widget.url_to_action "insert?page_type=#{allowed_children}"
                    else
                        # no insert
                        @bottom_toolbar('.page-insert-link').hide()
                        @bottom_toolbar('.page-insert-select-link').hide()

                # @bottom_toolbar(' .page-name').text row.contents
            else
                @bottom_toolbar('.page-actions').hide()
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
            $(@).attr 'href', pages_widget.url_to( lang, state.page_node_id )

        if @pages_reorder_enabled
            @top_toolbar('.pages-reorder-link').addClass "disabled"
            @top_toolbar('.pages-reorder-link .checkmark').show()
        else
            @top_toolbar('.pages-reorder-link').removeClass "disabled"
            @top_toolbar('.pages-reorder-link .checkmark').hide()


