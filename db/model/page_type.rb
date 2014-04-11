class PageType
  include Model

  field :type, type: Symbol
  field :name, type: String
  field :allowed_parents, type: Array
  field :allowed_children, type: Array
  field :allowed_content_blocks, type: Array
  field :defaults, type: Hash

  validates_uniqueness_of :type

  has_many :page_nodes

end # class PageType