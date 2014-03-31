#
#
log = (msg) ->
    console?.log "** admin/pages/edit:tabs: #{msg}"

current_lang = ->
    $('.page-content-tabs .tab-pane.active').attr 'id'

page_content_fields = (lang) ->
    $("input,textarea,select", ".page-content-#{lang} .field")

@page_content_clear = (lang) ->
    $(".page-content-#{lang}").find('input.marked-for-removal').val true
    $(".page-content-#{lang}").hide()
    page_content_fields(lang).prop 'disabled', true
    $(".page-content-empty-#{lang}").show()

@page_content_add = (lang) ->
    $(".page-content-#{lang}").find('input.marked-for-removal').val ''
    $(".page-content-#{lang}").show()
    page_content_fields(lang).prop 'disabled', false
    $(".page-content-empty-#{lang}").hide()

bind_event_listeners = ->
    $('.clear-page-content-link').on 'click', (e) ->
        e.preventDefault()
        page_content_clear current_lang()
        log "remove page content: #{current_lang()}"

    $('.add-page-content-link').on 'click', (e) ->
        e.preventDefault()
        lang = $(e.currentTarget).attr 'data-lang'
        page_content_add lang
        log "add page content: #{lang}"



$ ->
    bind_event_listeners()
    log "initialized"