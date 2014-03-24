preview_widget = null
preview_content = null
preview_empty = null
preview_toolbar = null
attached_footer = null
@page_preview_show = (id) ->
    if id?
        $.get "#{id}/preview", (data) ->
            preview_content.html data
            preview_content.show()
            preview_widget.find('.content').animate scrollTop: 0
            preview_empty.hide()
            preview_toolbar.show()
            attached_footer.update_footer()
            # pages_widget.open_middle()

    else
        preview_content.hide()
        preview_toolbar.hide()
        preview_empty.show()

    console?.log "** pane preview: showing page for id:#{id}"

$ ->
    preview_widget = $('.pane-preview').first()
    preview_content = preview_widget.find('#preview').first()
    preview_empty = preview_widget.find('#preview-empty').first()
    preview_toolbar = preview_widget.find('.bottom-toolbar').first()
    attached_footer = new AttachedFooter preview_content, preview_toolbar, $('.pane-preview .content')
    top_h = $("#top-menu").outerHeight()
    foot_h = $("#footer").outerHeight()
    # new AutofixedHeight $('.pane-preview'), top_h, top_h+foot_h
