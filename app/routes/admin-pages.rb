namespace "/admin/pages" do

  admin_menu "/admin/pages/", icon: 'fa-file', label: :'aerogel.admin.panes.pages', priority: 10

  get "/" do
    @pages = Page.traverse
    @selected_page = Page.find params[:selected_page_id] if params[:selected_page_id]
    pass
  end

  get "/:id/preview" do
    layout "admin/pages/preview"
    @page = Page.find params[:id]
    pass
  end

  #
  # Common User controller routes
  #
  route :get, :post, ['/', '/:action', '/:id/:action'] do
    action = params[:action] || 'index'
    view "admin/pages/#{action}"
  end

end