module Pages
  class Block
    include Model

    embedded_in :page

    field :position, type: Integer

    # Returns symbolized block type, inferred from class name.
    #
    def type
      self.class.name.split("::").last.underscore.to_sym
    end

    # Returns PageNode of the Page the block belongs to.
    #
    def page_node
      page.page_node
    end

    # Returns lang of the PageContent the block belongs to.
    #
    def lang
      page.lang
    end

    # Returns +true+ if block has configurable details.
    #
    def has_details?
      false
    end

    def self.has_details!
      define_method(:has_details?) { true }
    end

  end # class Block
end # module Pages
