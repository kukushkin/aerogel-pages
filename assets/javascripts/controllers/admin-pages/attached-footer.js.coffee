class @AttachedFooter
    float_footer: ->
        return if @is_floating
        @placeholder = $ "<div>"
        @placeholder.css 'display', 'block'
        @placeholder.height @footer.outerHeight()
        @element.after @placeholder
        @footer.css "position", "absolute"
        @footer.css "bottom", "0"
        @footer.addClass "floating"
        @footer.hide()
        console?.log "fadeing IN"
        @footer.fadeIn()
        @is_floating = true
        # console?.log "** footer is floating"

    unfloat_footer: ->
        return unless @is_floating
        @is_floating = false
        console?.log "fadeing OUT"
        # @footer.fadeOut done: =>
        @footer.show()
        @footer.css "position", "static"
        @footer.css "bottom", "auto"
        @placeholder.remove()
        @footer.removeClass "floating"
        # console?.log "** footer is unfloated"

    update_footer: ->
        view_y = $(window).scrollTop()
        view_b = view_y + $(window).height()
        el_y = @element.offset().top
        el_b = el_y + @element.height()
        ft_h = @footer.outerHeight()
        # console?.log "view_y:#{view_y}, view_b:#{view_b} el_b:#{el_b} "
        if view_b - ft_h  > el_b
            # element's bottom is on screen?
            @unfloat_footer()
        else
            @float_footer()

    constructor: (@element, @footer, @observer) ->
        @is_floating = false
        @update_footer()
        @observer.scroll =>
            @update_footer()
        # @element.scroll =>
        #    @update_footer()




@attach_floating_footer = (element, footer, observer) ->
    new AttachedFooter $(element), $(footer), observer
    console?.log "floating footer attached"
