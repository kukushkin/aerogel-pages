class Page
  include Model
  include Model::Timestamps

  # embedded_in :page
  belongs_to :page_node

  PUBLICATION_STATES = [:published, :hidden, :not_published]

  field :lang, type: Symbol
  field :published_at, type: Time
  field :publication_state, type: Symbol, default: :published
  field :link, type: String
  field :parent_links, type: Array, default: nil
  field :title, type: String
  field :html_description, type: String
  field :html_keywords, type: String

  before_save :update_links

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
    parts = [parent_links, link].flatten
    parts.shift # skip root page
    "/"+parts.join("/")
    # ( root? ? "/" ) : parts.join("/")
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

  def update_links
    self.parent_links = default_parent_links if parent_links.nil?
    update_children_links
  end

  # Generates default value for parent_links, that is used to populate new Page object.
  #
  # NOTE: This is impossible to do as field's default with Proc, because by some reason
  # Mongoid does not initialize relations at 'assign defaults' stage.
  #
  def default_parent_links
    # puts "** default_parent_links: self.page_node=#{self.page_node.inspect}"
    # puts "** default_parent_links: self=#{self.inspect}"
    parent_page = parent
    if parent_page.present?
      parent_page.parent_links + [parent_page.link]
    else
      []
    end
  end

  def update_children_links
    return unless link_changed? || parent_links_changed?
    # puts "** update children links fired"
    links = parent_links + [link]
    children.each do |p|
      p.update_attributes parent_links: links
    end
  end


end # class Page