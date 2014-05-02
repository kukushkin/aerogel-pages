class Page
  include Model
  include Model::Timestamps

  # embedded_in :page
  belongs_to :page_node, touch: true
  field :position, type: Integer # !!! denormalized from PageNode

  PUBLICATION_STATES = [:published, :hidden, :not_published]

  field :lang, type: Symbol
  field :published_at, type: Time
  field :publication_state, type: Symbol, default: :published
  field :link, type: String
  field :title, type: String
  field :html_description, type: String
  field :html_keywords, type: String

  before_create :denormalize_position
  before_update :touch_ancestors
  before_destroy :touch_ancestors

  embeds_many :page_blocks, class_name: "Pages::Block", order: :position.asc #, cascade_callbacks: true
  accepts_nested_attributes_for :page_blocks,
    reject_if: :all_blank,
    allow_destroy: true

  validates_presence_of :page_node_id, :lang, :title
  validates_presence_of :link, unless: :root?
  validates :publication_state, inclusion: { in: PUBLICATION_STATES }
  validates_uniqueness_of :lang, scope: [:page_node_id]

  # scope :children_of, ->(other_page) { where( :page_id.in => other_page.children.map(&:_id) ) }
  scope :published, where( :publication_state => :published )
  scope :published_and_hidden, where( :publication_state.in => [:published, :hidden] )

  # Create a new embedded page block.
  #
  def create_page_block( opts )
    pb = Aerogel::Pages.create_page_block opts[:type], opts
    pb.page = self
    pb
  end

  # Returns url to this page if it is accessible, constructed from the parent links.
  #
  def url
    parent_links = ancestors.sort_by(&:depth).map(&:link)
    parts = [parent_links, link].flatten
    parts.shift # skip root page
    "/"+parts.join("/")
    # ( root? ? "/" ) : parts.join("/")
  end

  # Returns page type of the page.
  #
  def page_type
    page_node.page_type
  end

  # Returns +true+ if this Page is root.
  #
  def root?
    page_node.try(:root?)
  end

  # Returns root in specified language.
  #
  def self.root( lang )
    PageNode.root.try( :page, lang )
  end

  # Returns parent page.
  #
  def parent
    page_node.parent.try( :page, lang )
  end

  # Returns children of this page.
  #
  def children
    Page.where( lang: lang, :page_node_id.in => page_node.children.map(&:_id) )
  end

  # Returns ancestors of this page.
  #
  def ancestors
    Page.where( lang: lang, :page_node_id.in => page_node.ancestors.map(&:_id) )
  end

  # Returns depth of the page_node
  #
  def depth
    page_node.depth
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


# private

  def denormalize_position
    # puts "** denormalizing position from page_node: #{page_node_id} -> #{page_node.inspect}"
    self.position = page_node.try(:position)
  end


  # Touches parents (if present)
  #
  def touch_ancestors
    ancestors.update_all updated_at: Time.now
    page_node.ancestors.update_all updated_at: Time.now
    page_node.touch
  end

end # class Page