# Modal dialogs for page and template/layout selection.
#

modal_result = null

@admin_modal_select_and_close = ( result ) ->
    console?.log "** amdin modal select and close: #{result}"
    modal_result = result
    $("#adminModal").modal 'hide'

@admin_modal_select_page_clear = (e) ->
    field = $(e.currentTarget).closest('.field-select-page')
    field.find('.page-node-id').val ''
    field.find('.page-label').val ''

@admin_modal_select_page_select = (e) ->
    field = $(e.currentTarget).closest('.field-select-page')
    modal_result = null
    select_lang = field.data 'lang'
    select_page_node_id = field.find(".page-node-id").val()
    $("#adminModal").modal
        remote: "edit/select_page?select_lang=#{select_lang}&select_page_node_id=#{select_page_node_id}"
    $("#adminModal").on 'hidden.bs.modal', ->
        if modal_result?
            console?.log "** select page: selected result: #{modal_result.page_id}, #{modal_result.page_label}"
            field.find('.page-node-id').val modal_result.page_node_id
            html_result = $.parseHTML(modal_result.page_label)
            text_result = $(html_result).text().replace(/^\s+|\s+$/g, '')
            field.find('.page-label').val text_result
        # on_select()
        $("#adminModal").off 'hidden.bs.modal'

@admin_modal_select_template_clear = (e) ->
    field = $(e.currentTarget).closest('.field-select-template')
    field.find('.template-id').val ''
    field.find('.template-label').val ''

@admin_modal_select_template_select = (e) ->
    field = $(e.currentTarget).closest('.field-select-template')
    modal_result = null
    select_template_prefix = field.data 'prefix'
    select_template_id = field.find(".template-id").val()
    $("#adminModal").modal
        remote: "edit/select_template?select_template_prefix=#{select_template_prefix}&select_template_name=#{select_template_id}"
    $("#adminModal").on 'hidden.bs.modal', ->
        if modal_result?
            console?.log "** select template: selected result: #{modal_result.template_id}"
            field.find('.template-id').val modal_result.template_id
            html_result = $.parseHTML(modal_result.template_label)
            text_result = $(html_result).text().replace(/^\s+|\s+$/g, '')
            field.find('.template-label').val text_result
        # on_select()
        $("#adminModal").off 'hidden.bs.modal'


# Install event handlers on select-page fields
$ ->
    $("body").on 'click', '.field-select-page .btn-clear', admin_modal_select_page_clear
    $("body").on 'click', '.field-select-page .btn-select', admin_modal_select_page_select
    $("body").on 'click', '.field-select-template .btn-clear', admin_modal_select_template_clear
    $("body").on 'click', '.field-select-template .btn-select', admin_modal_select_template_select

    console?.log "** select page fields installed"
