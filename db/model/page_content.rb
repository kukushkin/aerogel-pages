class PageContent
  include Model
  include Model::Timestamps

  embedded_in :page

  field :lang, type: Symbol
  field :link, type: String
  field :title, type: String
  field :content, type: String

  validates_presence_of :lang, :link, :title
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