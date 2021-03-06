# Returns publication state as icon,
# unless it is :published, in which case nothing is rendered.
#
def admin_pages_publication_state_as_icon( page_node, lang )
  page = page_node.page( lang )
  state = page.try(:publication_state) || :not_published
  case state.to_sym
    when :published then '' # icon 'fa-check'
    when :hidden then icon 'fa-eye', title: 'hidden'
    else
      icon 'fa-times', title: 'not published'
  end
end

# Returns page title for given +lang+, with respect to publication state.
#
def admin_pages_title_as_text( page_node, lang )
  page = page_node.page( lang )
  if page.nil?
    publication_state = :not_published
    other_page = page_node.pages.first
    if other_page.nil?
      return "<span class='nodata'>no translation</span>"
    end
    return "<span class='nodata'>#{other_page.lang}: #{h other_page.title}</span>"
  end
  case page.publication_state.to_sym
    when :published then h page.title
    when :hidden then "<span class='state-hidden'>#{h page.title}</span>"
    else
      "<span class='state-not-published'>#{h page.title}</span>"
  end
end

# Returns title and publication state as icon and text.
#
def admin_pages_title_as_icon_and_text( page_node, lang )
  admin_pages_publication_state_as_icon( page_node, lang )+" "+admin_pages_title_as_text( page_node, lang )
end


# Returns link to a page for given +lang+, with respect to publication state.
#
def admin_pages_link_as_text( page_node, lang )
  page = page_node.page( lang )
  return "<span class='nodata'>no content</span>" if page.blank?
  case page.publication_state.to_sym
    when :published then h( page.link )
    when :hidden then "<span class='state-hidden'>#{h page.link}</span>"
    else
      "<span class='state-not-published'>#{h page.link}</span>"
  end
end

# Returns link and publication state as icon and text.
#
def admin_pages_link_as_icon_and_text( page_node, lang )
  admin_pages_publication_state_as_icon( page_node, lang )+" "+admin_pages_link_as_text( page_node, lang )
end

# Returns full path to current page in given +lang+,
# links are generated as icon and text
#
def admin_pages_url_as_text( page_node, lang )
  return '' if page_node.nil?
  page_node.ancestors_and_self.sort_by(&:depth).map do |pn|
    if pn.root?
      icon 'fa-home'
    else
      admin_pages_link_as_icon_and_text pn, lang
    end
  end.join(" / ")
end

