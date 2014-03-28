namespace "/admin/pages" do

  admin_menu "/admin/pages/", icon: 'fa-file', label: :'aerogel.admin.panes.pages', priority: 10

  get "/", "/:lang-" do
    @pages = Page.traverse
    @lang = params[:lang] || I18n.default_locale
    pass
  end

  namespace "/:lang-:id" do
    before do
      @lang = params[:lang]
    end

    get do
      @pages = Page.traverse
      @selected_page = Page.find( params[:id] ) or halt 404
      pass
    end

    get "/preview" do
      layout "admin/pages/preview"
      @page = Page.find params[:id]
      pass
    end

    get "/append" do
      @selected_page = Page.find( params[:id] ) or halt 404
      @page = Page.new( parent_id: @selected_page.parent_id )
      @page.page_type = PageType.where( type: :page ).first
      pass
    end

    post "/append" do
      @selected_page = Page.find( params[:id] ) or halt 404
      @page = Page.new( params[:page] )
      @page.parent_id = @selected_page.parent_id
      pass unless @page.save
      @page.move_below @selected_page
      redirect "/admin/pages/#{@lang}-#{@page.id}"
    end

    get "/insert" do
      @selected_page = Page.find( params[:id] ) or halt 404
      @page = Page.new( parent_id: @selected_page.id )
      @page.page_type = PageType.where( type: :page ).first
      pass
    end

    post "/insert" do
      @selected_page = Page.find( params[:id] ) or halt 404
      @page = Page.new( params[:page] )
      @page.parent_id = @selected_page.id
      if @page.save
        redirect "/admin/pages/#{@lang}-#{@page.id}"
      end
      flash.now[:error] = t.aerogel.db.errors.failed_to_save( name: h( @page.id ),
        errors: @page.errors.full_messages.join(", ")
      )
      pass
    end

    get "/delete" do
      @page = Page.find( params[:id] ) or halt 404
      @selected_page = @page
      pass
    end

    post "/delete" do
      @page = Page.find( params[:id] ) or halt 404
      @selected_page = @page
      # pass unless @page.save
      redirect "/admin/pages/#{@lang}-#{@page.id}", error: "Not implemented yet"
    end


    get "/edit" do
      @page = Page.find params[:id]
      @selected_page = @page
      pass
    end

    post "/edit" do
      @page = Page.find( params[:id] ) or halt 404
      @selected_page = @page
      flash.now[:debug] = "params: #{params.inspect}"
      # pass
      #
      if @page.update_attributes params[:page].except( :page_type )
        redirect "/admin/pages/#{@lang}-#{@page.id}" #, notice: "Page updated"
      end
      flash.now[:error] = t.aerogel.db.errors.failed_to_save( name: h( @page.id ),
        errors: @page.errors.full_messages.join(", ")
      )
      pass
    end
  end # namespace ":lang\::id"
  #
  # Common Pages controller routes
  #
  route :get, :post, ['/', '/:id', '/:id/:action'] do
    action = params[:action] || 'index'
    view "admin/pages/#{action}"
  end

end