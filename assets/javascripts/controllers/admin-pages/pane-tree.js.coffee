tree = null
tree_selector = "#tree"
tree_column = 2
attached_footer = null

# Callback to be invoked when page (tree item) is selected
#
on_tree_item_selected = (id, object, el) =>
  if id?
    bottom_toolbar().show()
    update_bottom_toolbar object
    # element in view?
    el_t = el.position().top
    el_b = el_t + el.height()
    if el_t < 0 || $('.pane-tree .content').height() < el_b
      scroll_to_element el

  else
    selected_page = null
    $("#debug").text "selected none"
    bottom_toolbar().hide()

  # notify pages widget
  on_page_selected id, object

# Scroll view to element
#
scroll_to_element = (el) ->
  origin_to = $(tree_selector).position().top
  scroll_to = el.position().top
  console?.log "** pane-tree: scrolling to selected: #{scroll_to}: #{origin_to}"
  $('.pane-tree .content').animate { scrollTop: scroll_to - origin_to } #, 'slow'

# Returns action buttons elements, or elements within buttons specified by +selector+
#
bottom_toolbar = (selector = '') ->
  $('.pane-tree').find(".bottom-toolbar #{selector}")

# Updates action buttons state and labels
#
update_bottom_toolbar = (object) ->
  bottom_toolbar('.page-append-link').attr 'href', object.attributes['data-url-append']
  bottom_toolbar('.page-insert-link').attr 'href', object.attributes['data-url-insert']
  bottom_toolbar('.page-delete-link').attr 'href', object.attributes['data-url-delete']
  bottom_toolbar(' .page-name').text object.contents
  attached_footer.update_footer()


# Select item, bypass event handlers
@tree_select = (id) ->
  tree.select id # , false

# Expand item
@tree_expand = (id) ->
  tree.expand id


$ ->
  tree = new SmartTreeTable tree_selector,
    column: tree_column
    on_select: on_tree_item_selected
    prefix:
      branch:
        expanded: '<i class="prefix-expanded fa fa-caret-down"></i>'
        collapsed: '<i class="prefix-collapsed fa fa-caret-right"></i>'
      dragAndDrop:
        enabled: false
        dropTarget:
          overlay:
            before: '<i class="fa fa-long-arrow-up"></i>'
            into: '<i class="fa fa-long-arrow-right"></i>'
            after: '<i class="fa fa-long-arrow-down"></i>'

  on_tree_item_selected null

  top_h = $("#top-menu").outerHeight()
  foot_h = $("#footer").outerHeight()
  # new AutofixedHeight $('.pane-tree'), top_h, top_h + foot_h
  attached_footer = new AttachedFooter $(tree_selector), bottom_toolbar(), $('.pane-tree .content')

  console?.log "** admin/pages: pane-tree initialized"

