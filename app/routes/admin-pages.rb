namespace "/admin/pages" do

  admin_menu "/admin/pages/", icon: 'fa-file', label: :'aerogel.admin.panes.pages', priority: 10

  get "/:id?" do
    @pages = Page.traverse
    if params[:id]
      @selected_page = Page.find( params[:id] ) or halt 404
    end
    pass
  end

  get "/:id/preview" do
    layout "admin/pages/preview"
    @page = Page.find params[:id]
    pass
  end

  get "/:id/append" do
    @selected_page = Page.find( params[:id] ) or halt 404
    @page = Page.new
    pass
  end

  post "/:id/append" do
    @selected_page = Page.find( params[:id] ) or halt 404
    @page = Page.new( params[:page] )
    @page.parent_id = @selected_page.parent_id
    pass unless @page.save
    @page.move_below @selected_page
    redirect "/admin/pages/#{@page.id}"
  end

  get "/:id/insert" do
    @selected_page = Page.find( params[:id] ) or halt 404
    @page = Page.new
    pass
  end

  post "/:id/insert" do
    @selected_page = Page.find( params[:id] ) or halt 404
    @page = Page.new( params[:page] )
    @page.parent_id = @selected_page.id
    pass unless @page.save
    redirect "/admin/pages/#{@page.id}"
  end

  get "/:id/delete" do
    @page = Page.find( params[:id] ) or halt 404
    @selected_page = @page
    pass
  end

  post "/:id/delete" do
    @page = Page.find( params[:id] ) or halt 404
    @selected_page = @page
    # pass unless @page.save
    redirect "/admin/pages/#{@page.id}", error: "Not implemented yet"
  end


  get "/:id/edit" do
    @page = Page.find params[:id]
    @selected_page = @page
    pass
  end

  post "/:id/edit" do
    @page = Page.find( params[:id] ) or halt 404
    @selected_page = @page
    if @page.update_attributes params[:page]
      redirect "/admin/pages/#{@page.id}" #, notice: "Page updated"
    end
    flash.now[:error] = t.aerogel.db.errors.failed_to_save( name: h( @page.name ),
      errors: @page.errors.full_messages.join(", ")
    )
    pass
  end
  #
  # Common Pages controller routes
  #
  route :get, :post, ['/', '/:id', '/:id/:action'] do
    action = params[:action] || 'index'
    view "admin/pages/#{action}"
  end

end