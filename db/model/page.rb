class Page
  include Model
  include Model::OrderedTree

  before_destroy :destroy_children

  belongs_to :page_type
  has_many :page_contents, dependent: :destroy

  validates_presence_of :page_type

  accepts_nested_attributes_for :page_contents,
    reject_if: :all_blank,
    allow_destroy: true

  scope :with_content, ->(lang) { where( :'page_contents.lang' => lang ) }

  # Returns content for the specified +lang+.
  #
  def content( lang )
    page_contents.where( lang: lang.to_sym ).first
  end

  # Returns list of allowed content block types.
  #
  def available_block_types
    Aerogel::Pages.registered_page_block_types.keys
  end

  # Returns list of available langs as Symbols
  #
  def self.available_langs
    I18n.available_locales
  end

end # class Page
