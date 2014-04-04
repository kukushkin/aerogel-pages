module Pages::Blocks
  class Hr < Pages::Block

    Aerogel::Pages.register_page_block_type :hr, self

    # field :content, type: String

  end # class Text
end # module Pages