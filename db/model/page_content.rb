class PageContent
  include Model
  include Model::Timestamps

  belongs_to :page

  PUBLICATION_STATES = [:published, :hidden, :not_published]

  field :lang, type: Symbol
  field :published_at, type: Time
  field :publication_state, type: Symbol, default: :published
  field :link, type: String
  field :title, type: String
  field :html_description, type: String
  field :html_keywords, type: String

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

end # class PageContent