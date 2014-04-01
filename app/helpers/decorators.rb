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

def admin_pages_title_as_text( page, lang )
  page_content = page.content( lang )
  return "<span class='nodata'>no translation</span>" if page_content.blank?
  case page_content.publication_state.to_sym
    when :published then page_content.title
    when :hidden then "<span class='state-hidden'>#{h page_content.title}</span>"
    else
      "<span class='state-not-published'>#{h page_content.title}</span>"
  end
end

def admin_pages_title_as_icon_and_text( page, lang )
  admin_pages_publication_state_as_icon( page, lang )+" "+admin_pages_title_as_text( page, lang )
end

def admin_pages_link_as_text( page, lang )
  page_content = page.content( lang )
  return "<span class='nodata'>no content</span>" if page_content.blank?
  case page_content.publication_state.to_sym
    when :published then page_content.title
    when :hidden then "<span class='state-hidden'>#{h page_content.link}</span>"
    else
      "<span class='state-not-published'>#{h page_content.link}</span>"
  end
end

def admin_pages_link_as_icon_and_text( page, lang )
  admin_pages_publication_state_as_icon( page, lang )+" "+admin_pages_link_as_text( page, lang )
end

def admin_pages_url_as_text( page, lang )
  page.ancestors_and_self.sort_by(&:depth).map do |p|
    if p.root?
      icon 'fa-home'
    else
      admin_pages_link_as_icon_and_text p, lang
    end
  end.join(" / ")
end