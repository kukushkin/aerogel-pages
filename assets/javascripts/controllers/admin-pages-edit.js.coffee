#= require moment
#= require bootstrap-datetimepicker
#= require aerogel-media
#= require_tree ./admin-pages-edit
#= require admin-pages-utils/attached-footer


$ ->
    $('.datetimepicker').each ->
       new DatetimePickerField $(@)

    @attached_footer = new AttachedFooter
        target: $(".page-content-tabs")
        footer: $(".form-buttons")
        observe: $(window)
        position: 'fixed'

