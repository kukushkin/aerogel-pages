class PageContent
  include Model
  include Model::Timestamps

  embedded_in :page

  PUBLICATION_STATES = [:published, :hidden, :not_published]

  field :lang, type: Symbol
  field :published_at, type: Time
  field :publication_state, type: Symbol, default: :published
  field :link, type: String
  field :title, type: String
  field :html_description, type: String
  field :html_keywords, type: String

  embeds_many :page_blocks, class_name: "Pages::Block", cascade_callbacks: true
  accepts_nested_attributes_for :page_blocks,
    reject_if: :all_blank,
    allow_destroy: true

  validates_presence_of :lang, :link, :title
  validates :publication_state, inclusion: { in: PUBLICATION_STATES }



end # class PageContent