preview_widget = null
preview_content = null
preview_empty = null
preview_toolbar = null
attached_footer = null
@page_preview_show = (id, object) ->
    if id?
        url_preview = object.attributes['data-url-preview']
        url_edit = object.attributes['data-url-edit']
        $.get url_preview, (data) ->
            preview_content.html data
            preview_content.show()
            # preview_widget.find('.content').animate 'slow', scrollTop: 0
            preview_widget.find('.content').animate {scrollTop: 0} #, 'slow'
            preview_empty.hide()
            preview_toolbar.show()
            preview_toolbar.find('.page-edit-link').attr 'href', url_edit
            attached_footer.update_footer()
            # pages_widget.open_middle()

    else
        preview_content.hide()
        preview_toolbar.hide()
        preview_empty.show()

    # console?.log "** pane preview: showing page for id:#{id}"

$ ->
    preview_widget = $('.pane-preview').first()
    preview_content = preview_widget.find('#preview').first()
    preview_empty = preview_widget.find('#preview-empty').first()
    preview_toolbar = preview_widget.find('.bottom-toolbar').first()
    attached_footer = new AttachedFooter preview_content, preview_toolbar, $('.pane-preview .content')
    top_h = $("#top-menu").outerHeight()
    foot_h = $("#footer").outerHeight()
    # new AutofixedHeight $('.pane-preview'), top_h, top_h+foot_h
