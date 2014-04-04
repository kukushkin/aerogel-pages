module Pages::Blocks
  class Text < Pages::Block

    Aerogel::Pages.register_page_block_type :text, self

    field :content, type: String

  end # class Text
end # module Pages