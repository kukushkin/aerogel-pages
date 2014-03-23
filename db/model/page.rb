class Page
  include Model
  include Model::OrderedTree

  field :name, type: String
  field :value, type: String

  validates_presence_of :name

end # class Page