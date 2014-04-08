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
      parent_id = @page.parent_id
      @page.destroy
      redirect "/admin/pages/#{@lang}-#{parent_id}",
        notice: "Page \"#{admin_pages_title_as_text @page, @lang}\" deleted."
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

    get "/edit/page_block" do
      # Find or Create page and page content with given ids
      # and place the new block inside
      #
      page = Page.find( params[:page_block][:page_id] )
      unless page.present?
        page = Page.new
        page._id = params[:page_block][:page_id]
      end
      page_content = page.page_contents.find params[:page_block][:page_content_id]
      unless page_content.present?
        page_content = page.page_contents.new lang: params[:page_block][:lang]
        page_content._id = params[:page_block][:page_content_id]
      end
      page_block = page_content.create_page_block params[:page_block]
      field_prefix = "page[page_contents_attributes][#{page_content.lang}][page_blocks_attributes][#{page_block.id}]"
      opts = {
        field_prefix: field_prefix,
        style: 'admin-pages-edit-block'
      }
      fields = Aerogel::Forms::Fieldset.new page_block, nil, nil, opts do
        partial "admin/pages/edit/block", scope: self, locals: { type: params[:page_block][:type] }
      end
      fields.render
    end

    get "/edit/select_page" do
      @pages = Page.traverse
      @select_lang = params[:select_lang] || @lang
      @select_page_id = params[:select_page_id] || nil
      view "admin/pages/edit/select_page"
    end

    get "/edit/select_template" do
      @select_template_name = params[:select_template_name] || nil
      @select_template_prefix = params[:select_template_prefix] || nil
      @templates = []
      templates_wildcard = File.join( @select_template_prefix, '**/*.erb' )
      template_entry = Struct.new :id, :module, :filename
      Aerogel.get_resource_list( :views, templates_wildcard ) do |f, rf, path, base_path|
        id = rf
        filename = rf.sub(/^#{@select_template_prefix}/, '')
        module_name = base_path[:module_name]
        @templates << template_entry.new( id, module_name, filename )
      end

      view "admin/pages/edit/select_template"
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