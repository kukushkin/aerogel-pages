class PageNode
  include Model
  include Model::OrderedTree
  include Model::Timestamps

  before_destroy :destroy_children

  belongs_to :page_type
  has_many :pages, dependent: :destroy
  # embeds_many :pages, cascade_callbacks: true

  validates_presence_of :page_type

  accepts_nested_attributes_for :pages,
    reject_if: :all_blank,
    allow_destroy: true

  before_update :touch_ancestors
  before_destroy :touch_ancestors

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

private

  # Touches parents (if present)
  #
  def touch_ancestors
    ancestors.update_all updated_at: Time.now
  end



end # class Page
