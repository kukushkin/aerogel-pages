module Pages::Blocks
  class PagesList < Pages::Block

    Aerogel::Pages.register_page_block_type :pages_list, self

    field :target_page_node_id, type: String
    field :ordered_by, type: Symbol, default: :position
    field :ordered_asc, type: Symbol, default: :asc
    field :limit, type: Integer
    field :template, type: String
    field :show_hidden, type: Boolean, default: false

    has_details!

    def listed_pages
      return @_listed_pages_cache if @_listed_pages_cache
      target_page_node = target_page_node_id.present? ? PageNode.find( target_page_node_id ) : page_node
      return [] if target_page_node.nil?
      listed = target_page_node.page( lang ).children
      listed = (show_hidden ? listed.published_and_hidden : listed.published )
      if ordered_asc == :desc
        listed = listed.desc( ordered_by )
      else
        listed = listed.asc( ordered_by )
      end
      listed = listed.limit( limit ) if limit.present? && limit > 0
      @_listed_pages_cache = listed.to_a
      # listed
    end

    def listed_pages_DISABLED
      listed = listed_pages.map{|p| p.try :content, lang }.select{|pc| pc.present? }
      # listed = listed.order_by( ordered_by => (ordered_asc == :asc ? 1 : -1) )
      # listed = listed.limit( limit ) if limit.present? && limit > 0
      # listed
    end

  end # class Text
end # module Pages