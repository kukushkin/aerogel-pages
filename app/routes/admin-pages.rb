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
      @selected_page = Page.find( params[:id] ) or halt 404
    end

    get do
      @pages = Page.traverse
      pass
    end

    get "/preview" do
      layout "admin/pages/preview"
      @page = @selected_page
      pass
    end

    get "/append" do
      @page = Page.new( parent_id: @selected_page.parent_id )
      @page.page_type = PageType.where( type: :page ).first
      pass
    end

    post "/append" do
      @page = Page.new( params[:page] )
      @page.parent_id = @selected_page.parent_id
      pass unless @page.save
      @page.move_below @selected_page
      redirect "/admin/pages/#{@lang}-#{@page.id}"
    end

    get "/insert" do
      @page = Page.new( parent_id: @selected_page.id )
      @page.page_type = PageType.where( type: :page ).first
      pass
    end

    post "/insert" do
      @page = Page.new( params[:page] )
      @page.parent_id = @selected_page.id
      if @page.save
        redirect "/admin/pages/#{@lang}-#{@page.id}"
      end
      # flash.now[:error] = t.aerogel.db.errors.failed_to_save( name: h( @page.id ),
      #   errors: @page.errors.full_messages.join(", ")
      # )
      pass
    end

    get "/delete" do
      @page = @selected_page
      pass
    end

    post "/delete" do
      @page = @selected_page
      # pass unless @page.save
      redirect "/admin/pages/#{@lang}-#{@page.id}", error: "Not implemented yet"
    end


    get "/edit" do
      @page = @selected_page
      pass
    end

    post "/edit" do
      # flash.now[:debug] = "params: #{params.inspect}"
      @page = @selected_page
      if @page.update_attributes params[:page].except( :page_type )
        redirect "/admin/pages/#{@lang}-#{@page.id}" #, notice: "Page updated"
      end
      # flash.now[:error] = t.aerogel.db.errors.failed_to_save( name: h( @page.id ),
      #  errors: @page.errors.full_messages.join(", ")
      #)
      pass
    end

    get "/page_content_block" do
      # @page =
      page_content_lang = params[:page_content_lang]
      type = params[:type] || 'standard'
      pcb = PageContentBlock.new
      field_prefix = "page[page_contents_attributes][#{page_content_lang}][page_content_blocks_attributes][#{pcb.id}]"
      opts = {
        field_prefix: field_prefix,
        style: 'admin-pages-edit'
      }
      fields = Aerogel::Forms::Fieldset.new pcb, nil, nil, opts do
        partial "admin/pages/edit/content_block", scope: self, locals: { type: type }
      end
      fields.render
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