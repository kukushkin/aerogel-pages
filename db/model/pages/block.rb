module Pages
  class Block
    include Model

    embedded_in :page_content

    field :position, type: Integer

    # Returns symbolized block type, inferred from class name.
    #
    def type
      self.class.name.split("::").last.downcase.to_sym
    end

  end # class Block
end # module Pages
