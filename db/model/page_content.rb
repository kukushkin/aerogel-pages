class PageContent
  include Model
  include Model::Timestamps

  embedded_in :page

  PUBLICATION_STATES = [:published, :hidden, :not_published]

  field :lang, type: Symbol
  field :published_at, type: Time
  field :publication_state, type: Symbol
  field :link, type: String
  field :title, type: String
  field :content, type: String
  field :html_description, type: String
  field :html_keywords, type: String

  validates_presence_of :lang, :link, :title
  validates :publication_state, inclusion: { in: PUBLICATION_STATES }

  #
  # Page
  #   type: page
  #   allowed_children: *
  #  \PageContent:ru
  #    lang: ru
  #    link
  #    is_published
  #    is_visible
  #    created/updated/published
  #    title
  #
  #  \PageContent:en
  #

end # class PageContent