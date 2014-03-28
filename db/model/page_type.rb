class PageType
  include Model

  field :type, type: Symbol
  field :name, type: String
  field :allowed_children, type: Array
  field :allowed_content_blocks, type: Array

  has_many :pages

end # class PageType