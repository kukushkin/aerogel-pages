def admin_pages_publication_state_as_icon( state = nil )
  state ||= :not_published
  case state.to_sym
    when :published then icon 'fa-check'
    when :hidden then icon 'fa-eye'
    else
      icon 'fa-times'
  end
end