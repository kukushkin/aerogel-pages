class PageType
  include Model

  field :type, type: Symbol
  field :name, type: String
  field :allowed_parents, type: Array
  # field :allowed_children, type: Array
  field :allowed_content_blocks, type: Array
  field :defaults, type: Hash

  validates_uniqueness_of :type

  has_many :page_nodes


  def allowed_children
    self.class.where( :allowed_parents.in => [type] )
  end

end # class PageType


# :page -> [nil, :page]
# :news -> [:page]
# :news_article -> [:news]
#
