class @DatetimePickerField
    constructor: (@widget) ->
        @data_field = @widget.find('input').first()
        @field_id = @data_field.attr 'id'
        @helper_field = @data_field.clone()
        @helper_field.attr 'id', "#{@field_id}-helper"
        @helper_field.attr 'name', ''
        @helper_field.val ''
        @helper_field.removeClass 'datetimepicker'
        @helper_field.addClass 'datetimepicker-helper'
        @data_field.before @helper_field
        @data_field.attr 'type', 'hidden'
        @widget.before @data_field
        @widget.datetimepicker(
            language: I18n.locale()
        )
        console.log "setting date"
        # initial_date = "2013-10-11T12:00Z" # @data_field.val()
        initial_date = @data_field.val()
        # @datetimepicker().setDate "2013-10-11T12:00Z" #@data_field.val()
        @datetimepicker().setDate initial_date
        console.log "setting date to: '#{initial_date}', result: '#{@datetimepicker().getDate()?.format('L')}'"
        @widget.on "change.dp", (e) =>
            date = @datetimepicker().getDate()
            if date?
                console.log "date selected: #{date.format('L')}"
                @data_field.val date.toISOString()
            else
                console.log "setting date to empty string"
                @data_field.val ''
        console.log "DateTimePickerField created"
        # copy data field
        # ...
    datetimepicker: ->
        @widget.data("DateTimePicker")