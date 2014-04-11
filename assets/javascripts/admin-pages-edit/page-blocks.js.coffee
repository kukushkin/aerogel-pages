# page blocks functionality
#
#

page_block_lang = (el) ->
    el.closest('.page').attr 'data-lang'

page_blocks = (lang) ->
    $(".page-#{lang} .page-blocks fieldset.page_block")

page_block_delete = (el) ->
    marked_for_removal = el.closest('.page_block').find('.marked-for-removal')
    marked_for_removal.val 'true'
    console.log "page_block_delete():#{marked_for_removal.size()}", marked_for_removal

page_block_create = (el) ->
    lang = el.attr 'data-lang'
    opts =
        page_block:
            lang: el.attr 'data-lang'
            type: el.attr 'data-type'
            position: page_block_get_new_position( lang )
            page_node_id: el.attr 'data-page-node-id'
            page_id: el.attr 'data-page-id'

    console?.log "** creating new page block:", opts
    $.get "edit/page_block", opts, (data) =>
        $(".page-"+lang+" .page-blocks").append( data );

page_block_sort_start = (e, ui) ->
    console?.log "** page block sortable start"

page_block_sort_stop = (e, ui) ->
    position = 0
    $('.page-blocks fieldset.page_block').each ->
        $(@).find('.page-block-position').val position
        position += 1
    console?.log "** page block sortable stop"

page_block_get_max_position = (lang) ->
    max_position = 0
    page_blocks( lang ).each ->
        position = $(@).find('.page-block-position').val()
        position = parseInt( position )
        if !isNaN(position) && position > max_position
            max_position = position
    return max_position

page_block_get_new_position = (lang) ->
    if page_blocks( lang ).length > 0
        page_block_get_max_position( lang ) + 1
    else
        0

$ ->
    $('body').on 'click', '.btn-block-delete', ->
        page_block_delete $(@)

    $('body').on 'click', '.btn-block-create', ->
        page_block_create $(@)

    $('.page-blocks').sortable
        placeholder: 'page-block-sortable-placeholder'
        start: page_block_sort_start
        stop: page_block_sort_stop

