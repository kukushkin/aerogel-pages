module Pages::Blocks
  class PagesList < Pages::Block

    Aerogel::Pages.register_page_block_type :pages_list, self

    field :target_page_id, type: String
    field :ordered_by, type: Symbol, default: :position
    field :ordered_asc, type: Symbol, default: :asc
    field :limit, type: Integer
    field :template, type: String
    field :show_hidden, type: Boolean, default: false

    has_details!

    def listed_pages
      return @_listed_pages_cache if @_listed_pages_cache
      target_page = target_page_id.present? ? Page.find( target_page_id ) : page
      return [] if target_page.nil?
      listed = target_page.children.with_content( lang )
      listed = (show_hidden ? listed.published_and_hidden(lang) : listed.published(lang) )
      listed = listed.to_a
      unless ordered_by == :position
        listed = listed.sort_by do |p|
          p.content( lang ).try( :send, ordered_by ).try( :to_i ) || 0
        end
      end
      listed = listed.reverse if ordered_asc == :desc
      listed = listed.first( limit ) if limit.present? && limit > 0
      @_listed_pages_cache = listed
      listed
    end

    def listed_page_contents
      listed = listed_pages.map{|p| p.try :content, lang }.select{|pc| pc.present? }
      # listed = listed.order_by( ordered_by => (ordered_asc == :asc ? 1 : -1) )
      # listed = listed.limit( limit ) if limit.present? && limit > 0
      # listed
    end

  end # class Text
end # module Pages