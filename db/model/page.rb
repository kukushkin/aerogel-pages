class Page
  include Model
  include Model::OrderedTree

  before_destroy :destroy_children

  belongs_to :page_type
  embeds_many :page_contents, cascade_callbacks: true

  validates_presence_of :page_type

  accepts_nested_attributes_for :page_contents,
    reject_if: :all_blank,
    allow_destroy: true

  # Returns content for the specified +lang+.
  #
  def content( lang )
    page_contents.where( lang: lang.to_sym ).first
  end

  # Returns list of allowed content block types.
  #
  def available_content_block_types
    %w(text image some-other-block a aa aaa bbb bbbb sadasdasd asdsadsd sadasda asdasd adas asddad)
    # [:text, :image, :'some-other-block', :aaa, :]
  end

  # Returns list of available langs as Symbols
  #
  def self.available_langs
    I18n.available_locales
  end

end # class Page
