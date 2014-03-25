tree = null
tree_selector = "#tree"

# Callback to be invoked when page (tree item) is selected
#
on_tree_item_selected = (id, object, el) =>
  if id?
    action_buttons().show()
    update_action_buttons object

  else
    selected_page = null
    $("#debug").text "selected none"
    action_buttons().hide()

  # notify pages widget
  on_page_selected id, object

# Returns action buttons elements, or elements within buttons specified by +selector+
#
action_buttons = (selector = '') ->
  $(tree_selector).find(".actions .btn#{selector}")

# Updates action buttons state and labels
#
update_action_buttons = (object) ->
  action_buttons(' .page-name').text object.contents

@tree_select = (id) ->
  tree.select id
@tree_expand = (id) ->
  tree.expand id


$ ->
  tree = new SmartTreeTable tree_selector,
    column: 3
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

  console?.log "** admin/pages: pane-tree initialized"

