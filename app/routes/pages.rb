
# Locate page by URL
#
get "/*" do
  path = params[:splat].first.split "/" # .join "/"
  @page = Aerogel::Pages::Traversal.find path, current_locale
  pass if @page.nil?

  @page_content = @page.try :content, current_locale
  current_page @page_content
  page_title @page_content.title
  view "pages/view"
end

error do
  "Internal server error: #{h env['sinatra.error'].inspect}"
end