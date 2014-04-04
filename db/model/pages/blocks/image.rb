module Pages::Blocks
  class Image < Pages::Block

    ALIGNMENT_STATES = [:left, :middle, :right]

    field :image, type: Media::Image
    field :name, type: String
    field :alignment, type: Symbol, default: :middle
    field :thumb, type: String

    validates :alignment, inclusion: { in: ALIGNMENT_STATES }

    Aerogel::Pages.register_page_block_type :image, self

  end # class Text
end # module Pages