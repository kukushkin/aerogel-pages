class Page
  include Model
  include Model::OrderedTree

  field :name, type: String
  field :content, type: String

  validates_presence_of :name

end # class Page