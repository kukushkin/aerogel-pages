class PageContent
  include Model
  include Model::Timestamps

  embedded_in :page
  # belongs_to :page

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

  embeds_many :page_blocks, class_name: "Pages::Block", order: :position.asc, cascade_callbacks: true
  accepts_nested_attributes_for :page_blocks,
    reject_if: :all_blank,
    allow_destroy: true

  validates_presence_of :lang, :link, :title
  validates :publication_state, inclusion: { in: PUBLICATION_STATES }

  scope :children_of, ->(other_page) { where( :page_id.in => other_page.children.map(&:_id) ) }
  scope :published, where( :publication_state => :published )
  scope :published_and_hidden, where( :publication_state.in => [:published, :hidden] )

  # Create a new embedded page block.
  #
  def create_page_block( opts )
    pb = Aerogel::Pages.create_page_block opts[:type], opts
    pb.page_content = self
    pb
  end

  # Returns url to this page if it is accessible, constructed from the parent links.
  #
  def url
    parts = [parent_links, link].flatten
    parts.shift # skip root page
    "/"+parts.join("/")
  end

# private

  def update_links
    self.parent_links = default_parent_links if parent_links.nil?
    update_children_links
  end

  def default_parent_links
    puts "** default_parent_links: self.page=#{self.inspect}"
    puts "** default_parent_links: self=#{self.inspect}"
    parent = self.page.parent
    if parent.present?
      if parent.content(lang).present?
        pc = parent.content self.lang
        pc.parent_links + [pc.link]
      else
        [nil] # invalid parent link
      end
    else
      []
    end
  end

  def update_children_links
    return unless link_changed? || parent_links_changed?
    links = parent_links + [link]
    page.children.with_content( lang ).each do |p|
      p.content( lang ).update_attributes parent_links: links
    end
  end


end # class PageContent