
# Locate page by URL
#
get "/*" do
  path = params[:splat].first.split "/" # .join "/"
  @page = Aerogel::Pages::Traversal.find path, current_locale
  pass if @page.nil?

  current_page @page
  page_title @page.try( :title )
  view "pages/view"
end

error do
  "Internal server error: #{h env['sinatra.error'].inspect}"
end