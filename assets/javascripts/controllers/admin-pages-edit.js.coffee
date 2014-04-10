#= require moment
#= require bootstrap-datetimepicker
#= require smart-tree-table
#= require smart-list-table
#= require smart-links
#= require aerogel-media
#= require_tree ../admin-pages-edit
#= require admin-pages-utils/attached-footer

@select_page_dialog = (field) ->
    field = $("##{field}")
    console?.log "select page: from field #{field.val()}"
    $("#adminModal").modal
        remote: 'edit/select_page'


@select_template_dialog = (field) ->
    field = $("##{field}")
    console?.log "select template: from field #{field.val()}"
    $("#adminModal").modal
        remote: 'edit/select_template'


$ ->
    $('.datetimepicker').each ->
       new DatetimePickerField $(@)

    @attached_footer = new AttachedFooter
        target: $(".page-content-tabs")
        footer: $(".form-buttons")
        observe: $(window)
        position: 'fixed'

