namespace "/admin/pages" do

  admin_menu "/admin/pages/", icon: 'fa-file', label: :'aerogel.admin.panes.pages', priority: 10

  get "/", "/:lang-" do
    @page_nodes = PageNode.traverse
    @lang = params[:lang] || I18n.default_locale
    pass
  end

  namespace "/:lang-:id" do
    before do
      @lang = params[:lang]
      @selected_page_node = PageNode.find( params[:id] ) or halt 404
    end

    get do
      @page_nodes = PageNode.traverse
      pass
    end

    get "/preview" do
      layout "admin/pages/preview"
      @page_node = @selected_page_node
      pass
    end

    get "/append" do
      @page_node = PageNode.new( parent_id: @selected_page_node.parent_id )
      @page_node.page_type = PageType.where( type: :page ).first
      pass
    end

    post "/append" do
      @page_node = PageNode.new( params[:page_node] )
      @page_node.parent_id = @selected_page_node.parent_id
      pass unless @page_node.save
      @page_node.move_below @selected_page_node
      redirect "/admin/pages/#{@lang}-#{@page_node.id}"
    end

    get "/insert" do
      @page_node = PageNode.new( parent_id: @selected_page_node.id )
      @page_node.page_type = PageType.where( type: :page ).first
      pass
    end

    post "/insert" do
      @page_node = PageNode.new( params[:page_node] )
      @page_node.parent_id = @selected_page_node.id
      if @page_node.save
        redirect "/admin/pages/#{@lang}-#{@page_node.id}"
      end
      # flash.now[:error] = t.aerogel.db.errors.failed_to_save( name: h( @page.id ),
      #   errors: @page.errors.full_messages.join(", ")
      # )
      pass
    end

    get "/delete" do
      @page_node = @selected_page_node
      pass
    end

    post "/delete" do
      @page_node = @selected_page_node
      # pass unless @page.save
      parent_id = @page_node.parent_id
      @page_node.destroy
      redirect "/admin/pages/#{@lang}-#{parent_id}",
        notice: "Page \"#{admin_pages_title_as_text @page_node, @lang}\" deleted."
    end


    get "/edit" do
      @page_node = @selected_page_node
      pass
    end

    post "/edit" do
      # flash.now[:debug] = "params: #{params.inspect}"
      @page_node = @selected_page_node
      if @page_node.update_attributes params[:page_node].except( :page_type )
        redirect "/admin/pages/#{@lang}-#{@page_node.id}" #, notice: "Page updated"
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
      page_node = PageNode.find( params[:page_block][:page_node_id] )
      unless page_node.present?
        page_node = Page.new
        page_node._id = params[:page_block][:page_node_id]
      end
      page = page_node.pages.find params[:page_block][:page_id]
      unless page.present?
        page = page_node.pages.new lang: params[:page_block][:lang]
        page._id = params[:page_block][:page_id]
      end
      page_block = page.create_page_block params[:page_block]
      field_prefix = "page_node[pages_attributes][#{page.lang}][page_blocks_attributes][#{page_block.id}]"
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
      @page_nodes = PageNode.traverse
      @select_lang = params[:select_lang] || @lang
      @select_page_node_id = params[:select_page_node_id] || nil
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