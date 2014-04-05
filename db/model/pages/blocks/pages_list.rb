module Pages::Blocks
  class PagesList < Pages::Block

    Aerogel::Pages.register_page_block_type :pages_list, self

    field :content, type: String

  end # class Text
end # module Pages