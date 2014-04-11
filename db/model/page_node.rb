class PageNode
  include Model
  include Model::OrderedTree

  before_destroy :destroy_children

  belongs_to :page_type
  has_many :pages, dependent: :destroy
  # embeds_many :pages, cascade_callbacks: true

  validates_presence_of :page_type

  accepts_nested_attributes_for :pages,
    reject_if: :all_blank,
    allow_destroy: true

  # scope :with_content, ->(lang) { where( :'pages.lang' => lang ) }
  # scope :published, ->(lang) { elem_match( pages: { lang: lang, :publication_state => :published } ) }
  # scope :published_and_hidden, ->(lang) {
  #   elem_match( pages: { lang: lang, :publication_state.in => [:published, :hidden] } )
  # }

  # Returns content for the specified +lang+.
  #
  def page( lang )
    pages.where( lang: lang.to_sym ).first
  end

end # class Page
