#
#
log = (msg) ->
    console?.log "** admin/pages/edit:tabs: #{msg}"

current_lang = ->
    $('.page-tabs .tab-pane.active').attr 'id'

page_fields = (lang) ->
    $("input,textarea,select", ".page-#{lang} .field")

@page_clear = (lang) ->
    $(".page-#{lang}").find('input.marked-for-removal').val true
    $(".page-#{lang}").hide()
    page_fields(lang).prop 'disabled', true
    $(".page-empty-#{lang}").show()

@page_add = (lang) ->
    $(".page-#{lang}").find('input.marked-for-removal').val ''
    $(".page-#{lang}").show()
    page_fields(lang).prop 'disabled', false
    $(".page-empty-#{lang}").hide()

bind_event_listeners = ->
    $('.clear-page-content-link').on 'click', (e) ->
        e.preventDefault()
        page_clear current_lang()
        log "remove page content: #{current_lang()}"

    $('.add-page-content-link').on 'click', (e) ->
        e.preventDefault()
        lang = $(e.currentTarget).attr 'data-lang'
        page_add lang
        log "add page content: #{lang}"



$ ->
    bind_event_listeners()
    log "initialized"