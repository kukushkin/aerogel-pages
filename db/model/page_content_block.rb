class PageContentBlock
  include Model

  embedded_in :page_content

  field :content, type: String
  field :type, type: Symbol, default: :text

end # class PageContentBlock