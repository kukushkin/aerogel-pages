log = (msg) ->
    console?.log "** admin/pages:preview: #{msg}"

class @PanePreview
    constructor: (@element) ->
        @content = @element.find('.content').first()
        @preview = @element.find('#preview').first()
        @preview_empty = @element.find('#preview-empty').first()
        @toolbar = @element.find('.bottom-toolbar').first()
        @attached_footer = new AttachedFooter @preview, @toolbar, @content
        @current_page_id = null
        log "initialized"
        # ...
        #
    update: (state) ->
        if state.page_id?
            url_preview = pages_widget.url_to_action 'preview'
            url_edit = pages_widget.url_to_action 'edit'
            if @current_page_id != state.page_id
                $.get url_preview, (data) =>
                    @preview.html data
                    @preview.show()
                    @preview_empty.hide()
                    @content.animate {scrollTop: 0} #, 'slow'
                    @toolbar.show()
                    @toolbar.find('.page-edit-link').attr 'href', url_edit
                    @attached_footer.update_footer()
        else
            @preview.hide()
            @toolbar.hide()
            @preview_empty.show()
        @current_page_id = state.page_id


