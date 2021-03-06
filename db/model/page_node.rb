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
  before_update :touch_pages
  before_update :denormalize_position
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

  # Returns allowed page types (depending on the parent page type).
  #
  def allowed_page_types
    if parent.present?
      parent.page_type.allowed_children
    else
      PageType.where( type: :root ).first
    end
  end

private

  # Touches parents (if present)
  #
  def touch_ancestors
    ancestors.update_all updated_at: Time.now
  end

  # Touches pages (if present)
  #
  def touch_pages
    pages.update_all updated_at: Time.now
  end

  # Denormalize +position+ to owned Page(s).
  #
  def denormalize_position
    pages.update_all( position: position )
  end

end # class Page
