# Returns or sets current Page object being served.
#
def current_page( page = nil )
  @current_page = page if page.present?
  @current_page
end

# Returns current page url, if Page is served,
# plain ULR otherwise.
#
# If opts[:locale] is specified, tries to find closest page in other lang.
#
def current_page_url( opts = {} )
  if current_page.present?
    if !opts.key?(:locale) || opts[:locale] == current_page.lang
      current_page.url
    else
      # find this page in other lang
      other_page = Aerogel::Pages::Traversal.find_closest_in_other_lang( current_page.page, opts[:locale] )
      return nil unless other_page.present?
      url_to( other_page.content( opts[:locale] ).url, opts )
    end
  else
    current_url opts
  end
end