# Returns publication state as icon,
# unless it is :published, in which case nothing is rendered.
#
def admin_pages_publication_state_as_icon( page, lang )
  page_content = page.content( lang )
  state = page_content.try(:publication_state) || :not_published
  case state.to_sym
    when :published then '' # icon 'fa-check'
    when :hidden then icon 'fa-eye', title: 'hidden'
    else
      icon 'fa-times', title: 'not published'
  end
end

# Returns page title for given +lang+, with respect to publication state.
#
def admin_pages_title_as_text( page, lang )
  page_content = page.content( lang )
  if page_content.nil?
    publication_state = :not_published
    other_page_content = page.page_contents.first
    if other_page_content.nil?
      return "<span class='nodata'>no translation</span>"
    end
    return "<span class='nodata'>#{other_page_content.lang}: #{h other_page_content.title}</span>"
  end
  case page_content.publication_state.to_sym
    when :published then h page_content.title
    when :hidden then "<span class='state-hidden'>#{h page_content.title}</span>"
    else
      "<span class='state-not-published'>#{h page_content.title}</span>"
  end
end

# Returns title and publication state as icon and text.
#
def admin_pages_title_as_icon_and_text( page, lang )
  admin_pages_publication_state_as_icon( page, lang )+" "+admin_pages_title_as_text( page, lang )
end


# Returns link to a page for given +lang+, with respect to publication state.
#
def admin_pages_link_as_text( page, lang )
  page_content = page.content( lang )
  return "<span class='nodata'>no content</span>" if page_content.blank?
  case page_content.publication_state.to_sym
    when :published then h( page_content.link )
    when :hidden then "<span class='state-hidden'>#{h page_content.link}</span>"
    else
      "<span class='state-not-published'>#{h page_content.link}</span>"
  end
end

# Returns link and publication state as icon and text.
#
def admin_pages_link_as_icon_and_text( page, lang )
  admin_pages_publication_state_as_icon( page, lang )+" "+admin_pages_link_as_text( page, lang )
end

# Returns full path to current page in given +lang+,
# links are generated as icon and text
#
def admin_pages_url_as_text( page, lang )
  return '' if page.nil?
  page.ancestors_and_self.sort_by(&:depth).map do |p|
    if p.root?
      icon 'fa-home'
    else
      admin_pages_link_as_icon_and_text p, lang
    end
  end.join(" / ")
end

