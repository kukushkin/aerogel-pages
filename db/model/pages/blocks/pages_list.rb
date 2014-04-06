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

    def listed_page_contents
      listed = PageContent.children_of(page).where( lang: lang )
      listed = (show_hidden ? listed.published_and_hidden : listed.published )
      listed = listed.order_by( ordered_by => (ordered_asc == :asc ? 1 : -1) )
      listed = listed.limit( limit ) if limit.present? && limit > 0
      listed
    end

  end # class Text
end # module Pages