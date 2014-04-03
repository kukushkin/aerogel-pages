#= require moment
#= require bootstrap-datetimepicker
#= require_tree ./admin-pages-edit
#= require admin-pages-utils/attached-footer

page_content_block_delete = (el) ->
    marked_for_removal = el.closest('.page_content_block').find('.marked-for-removal')
    marked_for_removal.val 'true'
    console.log "page_content_block_delete():#{marked_for_removal.size()}", marked_for_removal

page_content_block_create = (el) ->
    lang = el.attr 'data-lang'
    opts =
        page_content_lang: el.attr 'data-lang'
        page_content_block_type: el.attr 'data-type'
    $.get "page_content_block", opts, (data) =>
        $(".page-content-"+lang+" .page-content-blocks").append( data );



$ ->
    $('.datetimepicker').each ->
       new DatetimePickerField $(@)

    $('body').on 'click', '.btn-block-delete', ->
        page_content_block_delete $(@)

    $('body').on 'click', '.btn-block-create', ->
        page_content_block_create $(@)

    @attached_footer = new AttachedFooter
        target: $(".page-content-tabs")
        footer: $(".form-buttons")
        observe: $(window)
        position: 'fixed'

