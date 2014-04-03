smart_link_effect_duration = 100


smart_link_effect_hide = (target, effect, fn) ->
    opts = { duration: smart_link_effect_duration, complete: fn }
    console.log "smart_link_effect_hide: #{effect}"
    switch effect
        when 'show'
            target.hide()
            fn()
        when 'fade'
            target.fadeOut opts
        when 'slide'
            target.slideUp opts

smart_link_effect_show = (target, effect) ->
    opts = { duration: smart_link_effect_duration }
    console.log "smart_link_effect_show: #{effect}"
    switch effect
        when 'show'
            target.show()
        when 'fade'
            target.fadeIn opts
        when 'slide'
            target.slideDown opts

smart_link_click = (e) ->
    console?.log "smart link clicked: #{e}"
    el = $(e.currentTarget)
    show_id = el.attr 'data-show-id'
    hide_id = el.attr 'data-hide-id'
    effect = (el.attr 'data-effect') || 'show'
    if hide_id?
        smart_link_effect_hide $(hide_id), effect, ->
            smart_link_effect_show $(show_id), effect
    else
        smart_link_effect_show $(show_id), effect
    e.preventDefault()
    false

$ ->
    $('body').on 'click', '.smart-link', smart_link_click